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

NSString *sessionName = @"SOMESECRETKEY";

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
        if ([session.sessionName isEqualToString:sessionName]) {
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
  [self.client createSessionWithName:sessionName
                                tags: @[@"eecs441"]
                            password:nil
                         startPaused:NO
                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                     [self notifySession:error];
                   }];
}

- (void)sendTextActions:(Deque *)finalEdits {
  NSLog(@"The text did change. %d edits.", finalEdits.size);
}

-(void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
  
  if([eventType isEqualToString:@"CursorUpdate"]) {
    // cursor change
    CursorUpdate *cu = new CursorUpdate();
    cu->MessageLite::ParseFromArray((const void*) CFBridgingRetain(data), data.length);
    
    CursorAction *action = [[CursorAction alloc] initWithServerUpdate:cu];
    
    NSLog(@"user: %d, position: %d", cu->user(), cu->position());
    
    [self.incomingActions push:action];
    
  } else if ([eventType isEqualToString:@"TextChange"]) {
    // text change
    TextUpdate *tc = new TextUpdate();
    tc->MessageLite::ParseFromArray((const void*) CFBridgingRetain(data), data.length);
    
    ServerTextAction *action = [[ServerTextAction alloc] initWithServerUpdate:tc];
    
    NSLog(@"user: %d, text: %s, type: %d", tc->user(), tc->text().c_str(), tc->type());
        
    [self.incomingActions push:action];
    
  }
}

@end
