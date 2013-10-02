//
//  TextCollabrifyClient.mm
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Actions.h"
#import "CollabrifyClient.h"
#import "CollabrifySession.h"
#import "Constants.h"
#import "Deque.h"
#import "froto/text.pb.h"
#import "TextCollabrifyClient.h"

@interface TextCollabrifyClient () <CollabrifyClientDelegate, CollabrifyClientDataSource>

@end


NSString* SESSION_NAME = @"bfdfladfdfbdkslkjx";
NSString* EDIT_SERIES_EVENT = @"EDIT_SERIES_EVENT";

@implementation TextCollabrifyClient

+ (id)sharedClient {
  // generate singleton
  static TextCollabrifyClient *client = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    client = [[self alloc] init];
  });
  return client;
}

- (id)init {
  if (self = [super init]) {
    // Init our client.
    NSError *err;
    _client = [[CollabrifyClient alloc] initWithGmail:@"wjbillin@umich.edu"
                                          displayName:@"Josh+Otto"
                                         accountGmail:@"441fall2013@umich.edu"
                                          accessToken:@"XY3721425NoScOpE"
                                       getLatestEvent:NO
                                                error:&err];
  
    _userCursors = [[NSMutableDictionary alloc] init];
    _incomingActions = [[Deque alloc] init];    
    
    [self.client setDelegate:self];
    [self.client setDataSource:self];
  }
  
  return self;
}

- (void)findSession {
  // Check if our session already exists, either join the session or create one.
  [[self client] listSessionsWithTags:@[ @"eecs441" ]
                    completionHandler:^(NSArray *sessionList, CollabrifyError *error) {
      BOOL found = NO;
                      
      for(CollabrifySession *session in sessionList) {
        if ([session.sessionName isEqualToString:SESSION_NAME] && !session.sessionHasEnded) {
          NSLog(@"Session owner is %@", session.owner.gmail);
          found = YES;
          [self joinSession:session];
        }
      }
      if (!found) {
        [self createSession];
      }
  }];
}

- (void)joinSession:(CollabrifySession *)session {
  // join a session
  [[self client] joinSessionWithID:session.sessionID
                          password:nil
                 completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error) {
                   [self notifySession:error];
                 }];
}

- (void)notifySession:(CollabrifyError *) err {
  // Tell view controller to show the text view.
  
  if (err) {
    NSLog(@"Session joining error %@", [err localizedDescription]);
    return;
  }
  
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification
                                                          notificationWithName:@"SESSION_JOINED"
                                                          object:nil]];
}

- (void)createSession {
  [self.client createSessionWithName:SESSION_NAME
                                tags: @[ @"eecs441" ]
                            password:nil
                         startPaused:NO
                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                     [self notifySession:error];
                   }];
}

- (void)deleteSession {
  [self.client leaveAndDeleteSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
    if (!success) {
      NSLog(@"Failed to delete session!");
    } else {
      NSLog(@"Deleted session.");
    }
  }];
}

- (void)sendActionsAndSync:(Deque *)localActions {
  NSLog(@"The text did change. %d edits.", localActions.size);
  
  id action;
  EditSeries *editSeries = new EditSeries();
  editSeries->set_user(self.client.participantID);
  
  while ((action = [localActions popQueue])) {
    Edit* edit = editSeries->add_edits();
    
    // Check if action is a cursor position change or a text action.
    if ([action isKindOfClass:[TextAction class]]) {
      TextAction *textAction = action;
      edit->set_type(
        (textAction.editType == INSERT) ? Edit_ChangeType_INSERT : Edit_ChangeType_REMOVE);
      edit->set_text([textAction.text cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    } else {
      CursorAction *cursorAction = action;
      edit->set_type(Edit_ChangeType_CURSOR);
      edit->set_location(cursorAction.position);
    }
  }
  
  // Serialize the proto.
  int size = editSeries->ByteSize();
  void* bytes = malloc(size);
  editSeries->SerializeToArray(bytes, size);
    
  // Broadcast the proto.
  int submissionID =
      [self.client broadcast:[NSData dataWithBytes:bytes length:size] eventType:EDIT_SERIES_EVENT];
  
  if (submissionID == -1) {
    NSLog(@"Error broadcasting.");
  }
}

- (void)receiveActions {
  
  // Deque of updates to eventually send to text delegate.
  Deque *finishedUpdates = [[Deque alloc] init];
  
  while ([self.incomingActions size] > 0) {
    if([[self.incomingActions back] isKindOfClass:CursorAction.class]) {
      // This is a cursor movement.
      CursorAction *cursorAction = [self.incomingActions popQueue];
      
      [self.userCursors setObject:[NSNumber numberWithInt:cursorAction.position]
                           forKey:[NSNumber numberWithInt:cursorAction.user]];
    } else {
      // Text action. Figure out the location/length of this text edit.
      TextAction *textAction = [self.incomingActions popQueue];

      NSNumber *user = [NSNumber numberWithInteger:textAction.user];
      NSNumber *loc = [self.userCursors objectForKey:user];
      
      int location = loc.intValue;
      int length = (textAction.editType == REMOVE) ? textAction.text.length : 0;
      textAction.range = NSMakeRange(location, length);
      
      [self updateCursors:textAction];
      
      [finishedUpdates pushBack:textAction];
    }
  }
  
  // Create a dictionary to hold the finished edits.
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[ finishedUpdates ]
                                                     forKeys:@[ renderUpdatesDictName ]];
  
  // Notify the text delegate that there are text edits to render.
  [[NSNotificationCenter defaultCenter]
      postNotification:[NSNotification notificationWithName:renderUpdatesNotificationName
                                                     object:nil
                                                   userInfo:dict]];
}

// Loop through the cursors and update the positions based on the text action.
- (void)updateCursors:(TextAction *)textAction {
  int leftIndex = textAction.range.location - textAction.range.length;
  int rightIndex = (textAction.editType == REMOVE) ?
      textAction.range.location : textAction.range.location + textAction.text.length;
  
  for (id key in [self.userCursors allKeys]) {
    NSNumber* location = [self.userCursors objectForKey:key];
    NSLog(@"cursor location is %d, action location: %d, length: %d, text: [%@]",
          location.intValue, textAction.range.location, textAction.range.length, textAction.text);
    if (textAction.editType == REMOVE) {
      if (location.intValue > rightIndex) {
        location = [NSNumber numberWithInt:(location.intValue - textAction.range.length)];
      } else if (location.intValue > leftIndex) {
        location = [NSNumber numberWithInt:leftIndex];
      }
    } else {
      if (location.intValue >= leftIndex) {
        location = [NSNumber numberWithInt:(location.intValue + textAction.text.length)];
      }
    }
    
    [self.userCursors setObject:location forKey:key];
  }
}


- (void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
  
  EditSeries *editSeries = new EditSeries();
  editSeries->ParseFromArray([data bytes], data.length);
  
  for (int i = 0; i < editSeries->edits_size(); ++i) {
    const ::Edit edit = editSeries->edits(i);
    
    if (edit.type() == Edit_ChangeType_CURSOR) {
      CursorAction *cursorAction =
          [[CursorAction alloc] initWithPosition:edit.location() user:editSeries->user()];
      
      [self.incomingActions pushBack:cursorAction];
    } else {
      EditType type = (edit.type() == Edit_ChangeType_INSERT) ? INSERT : REMOVE;
      NSString* text = [NSString stringWithCString:edit.text().c_str() encoding:NSASCIIStringEncoding];
      TextAction *textAction =
          [[TextAction alloc] initWithUser:editSeries->user() text:text editType:type];
      
      [self.incomingActions pushBack:textAction];
    }
  }
  
  // Actually process the actions. Yay!
  [self receiveActions];
  
}

@end
