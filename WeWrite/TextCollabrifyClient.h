//
//  TextCollabrifyClient.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <Collabrify/Collabrify.h>
#import <Foundation/Foundation.h>

@class Deque;

@interface TextCollabrifyClient : NSObject

@property (nonatomic, retain) CollabrifyClient* client;
@property (nonatomic, retain) Deque *incomingActions;
@property (nonatomic, assign) BOOL selfChangeInFlight;

+ (id)sharedClient;

- (id)init;
- (void)findSession;
- (void)deleteSession;
- (int64_t)getSelfID;
- (void)sendActions:(Deque *)finalEdits;

@end
