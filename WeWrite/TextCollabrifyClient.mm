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
#import "TextAction.h"
#import "Deque.h"

@interface TextCollabrifyClient () <CollabrifyClientDelegate, CollabrifyClientDataSource>

@end

NSString *sessionName = @"SOMESECRETKEY";

@implementation TextCollabrifyClient

- (id)initWithViewController:(TextViewController *)viewController {
  if (self = [super init]) {
    _textViewController = viewController;
    
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
     if (error) {
       NSLog(@"Session joining error %@", [error localizedDescription]);
       return;
     }
                   
     // Tell view controller to show the text view.
     [[NSNotificationCenter defaultCenter] postNotification:[NSNotification
                                                             notificationWithName:@"SESSION_JOINED"
                                                              object:error]];
                   
   }];
}

- (void)createSession {
  [self.client createSessionWithName:sessionName
                                tags: @[@"eecs441"]
                            password:nil
                         startPaused:NO
                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
    if (error) {
      NSLog(@"Creating session error %@", [error localizedDescription]);
      return;
    }
    // Tell view controller to show the shit.
    [self.textViewController joinedSession];
   
  }];
}

- (void) textDidChange:(Deque *)finalEdits {
  NSLog(@"The text did change. %d edits.", finalEdits.size);
}

-(void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
  
  if([eventType isEqualToString:@"CursorUpdate"]) {
    // cursor change
    CursorUpdate cu;
    cu.MessageLite::ParseFromArray((const void*) CFBridgingRetain(data), data.length);
    
    
    
    NSLog(@"user: %d, position: %d", cu.user(), cu.position());
    
  } else if ([eventType isEqualToString:@"TextChange"]) {
    // text change
    TextChange tc;
    tc.MessageLite::ParseFromArray((const void*) CFBridgingRetain(data), data.length);
    
    TextAction *action = [[TextAction alloc] init:tc.user()
                                             text:[NSString stringWithUTF8String:tc.text().c_str()]
                                         editType:(tc.type() == TextChange::INSERT)? INSERT : REMOVE];
    
    NSLog(@"user: %d, text: %s, type: %d", tc.user(), tc.text().c_str(), tc.type());
    
        
    [self.incomingActions push:action];
    
  }
}

@end
