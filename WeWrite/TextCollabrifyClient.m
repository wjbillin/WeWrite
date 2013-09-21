//
//  TextCollabrifyClient.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "TextViewController.h"
#import "TextCollabrifyClient.h"
#import "CollabrifyClient.h"
#import "CollabrifySession.h"

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

@end
