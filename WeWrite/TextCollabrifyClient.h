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
@property (nonatomic, retain) NSMutableDictionary *userCursors;

+ (id)sharedClient;

- (id)init;
- (void)findSession;
- (void)deleteSession;
- (void)sendActions:(Deque *)finalEdits;

@end
