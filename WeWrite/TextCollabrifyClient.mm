//
//  TextCollabrifyClient.mm
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "TextViewController.h"
#import "TextCollabrifyClient.h"
#import "CollabrifyClient.h"
#import "CollabrifySession.h"
#import "froto/text.pb.h"
#import "Actions.h"
#import "Deque.h"

@interface TextCollabrifyClient () <CollabrifyClientDelegate, CollabrifyClientDataSource>

@end

NSString* SESSION_NAME = @"SOMESECRETKEY";
NSString* TEXT_EVENT = @"TEXT_EVENT";
NSString* CURSOR_EVENT = @"CURSOR_EVENT";

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
    
    [[self client] setDelegate:self];
    [[self client] setDataSource:self];
  }
  
  return self;
}

- (void)findSession {
  // Check if our session already exists, either join the session or create one.
  [[self client] listSessionsWithTags:@[@"eecs441"]
                    completionHandler:^(NSArray *sessionList, CollabrifyError *error) {
      BOOL found = NO;
                      
      for(CollabrifySession *session in sessionList) {
        if ([session.sessionName isEqualToString:SESSION_NAME]) {
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
                                tags: @[@"eecs441"]
                            password:nil
                         startPaused:NO
                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                     [self notifySession:error];
                   }];
}

- (void)sendTextActions:(Deque *)finalEdits {
  NSLog(@"The text did change. %d edits.", finalEdits.size);
  
  LocalTextAction* action;
  while ((action = [finalEdits popQueue])) {
    TextUpdate* textUpdate = new TextUpdate();
    textUpdate->set_user(self.client.participantID);
    textUpdate->set_type(
        (action.editType == INSERT) ? TextUpdate_ChangeType_INSERT : TextUpdate_ChangeType_REMOVE);
    textUpdate->set_text([action.text cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    
    // Serialize the proto.
    int size = textUpdate->ByteSize();
    void* buffer = malloc(size);
    textUpdate->SerializeToArray(buffer, size);
    
    // Broadcast the proto.
    int submissionID =
        [self.client broadcast:[NSData dataWithBytes:buffer length:size] eventType:TEXT_EVENT];
    
    if (submissionID == -1) {
      NSLog(@"Error broadcasting. Aborting call.");
      return;
    }
    [self.unconfirmedActions setObject:action forKey:[NSString stringWithFormat:@"%d", submissionID]];
  }
}

- (void)receiveActions {
  
  Deque *incomingTextEdits = [[Deque alloc] init];
  
  // record cursor movements
  while ([self.incomingActions size] != 0) {
    if([[self.incomingActions front] isKindOfClass:CursorAction.class]) {
      // this is a cursor movement
      CursorAction *cursor = [self.incomingActions popQueue];
      
      [self.userCursors setObject:@(cursor.position) forKey:@(cursor.user)];
      
    } else {
      // this is a text add
      ServerTextAction *serverAction = [self.incomingActions popQueue];
      NSInteger user = serverAction.user;
      NSNumber *loc = [self.userCursors objectForKey:@(user)];
      int len = (serverAction.editType == REMOVE)? serverAction.text.length : 0;
      LocalTextAction *localAction = [[LocalTextAction alloc] initWithRange:NSMakeRange(loc.intValue, len)
                                                                       text:serverAction.text];
      [incomingTextEdits push:localAction];
      
    }
  }
  // notify TextViewDelegate with changes
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification
                                                          notificationWithName:@"TEXT_RECEIVED"
                                                          object:incomingTextEdits]];


}

-(void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
  
  if([eventType isEqualToString:CURSOR_EVENT]) {
    // cursor change
    CursorUpdate *cu = new CursorUpdate();
    cu->ParseFromArray([data bytes], data.length);
    
    CursorAction *action = [[CursorAction alloc] initWithPosition:cu->position() user:cu->user()];
    
    NSLog(@"user: %lld, position: %d", cu->user(), cu->position());
    
    [self.incomingActions push:action];
    
  } else if ([eventType isEqualToString:TEXT_EVENT]) {
    // text change
    TextUpdate *tc = new TextUpdate();
    tc->ParseFromArray([data bytes], data.length);
    
    NSString* textString = [NSString stringWithCString:tc->text().c_str()
                                              encoding:[NSString defaultCStringEncoding]];
    EditType editType = (tc->type() == TextUpdate_ChangeType_INSERT) ? INSERT : REMOVE;
    ServerTextAction *action =
        [[ServerTextAction alloc] initWithServerUpdate:tc->user()
                                                  text:textString
                                              editType:editType];
    
    //NSLog(@"user: %lld, text: %s, type: %d", tc->user(), tc->text().c_str(), tc->type());
        
    [self.incomingActions push:action];
  }
  
  // ingest and rectify the actions
  [self receiveActions];
  
}

@end
