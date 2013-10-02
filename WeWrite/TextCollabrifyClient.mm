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


NSString* SESSION_NAME = @"bfdfladfdfbdkslkjzzzb";
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
    _incomingActions = [[Deque alloc] init];
    _selfChangeInFlight = NO;
    
    [self.client setDelegate:self];
    [self.client setDataSource:self];
  }
  
  return self;
}

- (int64_t)getSelfID {
  return self.client.participantID;
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

- (void)sendActions:(Deque *)localActions {
  NSLog(@"The text did change. %d edits.", localActions.size);
  
  id action;
  EditSeries *editSeries = new EditSeries();
  editSeries->set_user(self.client.participantID);
  
  while ((action = [localActions popFront])) {
    Edit* edit = editSeries->add_edits();
    
    // Check if action is a cursor position change or a text action.
    if ([action isKindOfClass:[TextAction class]]) {
      TextAction *textAction = action;
      edit->set_type(
        (textAction.editType == INSERT) ? Edit_ChangeType_INSERT : Edit_ChangeType_REMOVE);
      edit->set_text([textAction.text cStringUsingEncoding:[NSString defaultCStringEncoding]]);
      edit->set_isundo(textAction.isUndo);
      edit->set_location(textAction.range.location);
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
    return;
  }
  
  self.selfChangeInFlight = YES;
}


- (void)client:(CollabrifyClient *)client
    receivedEventWithOrderID:(int64_t)orderID
    submissionRegistrationID:(int32_t)submissionRegistrationID
                   eventType:(NSString *)eventType
                        data:(NSData *)data {
  
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
      textAction.isUndo = edit.isundo();
      textAction.range = NSMakeRange(edit.location(), 0);
      
      [self.incomingActions pushBack:textAction];
    }
  }
  
  if (editSeries->user() == self.client.participantID) {
    self.selfChangeInFlight = NO;
  }
  
  // Create a dictionary to hold the finished edits.
  Deque* incomingActionsCopy = [Deque dequeWithDeque:self.incomingActions];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[ incomingActionsCopy ]
                                                     forKeys:@[ renderUpdatesDictName ]];
  
  // Notify the text delegate that there are text edits to render.
  [[NSNotificationCenter defaultCenter]
   postNotification:[NSNotification notificationWithName:renderUpdatesNotificationName
                                                  object:nil
                                                userInfo:dict]];
  
  // Clear the incoming edits.
  [self.incomingActions clear];
}

@end
