//
//  TextCollabrifyClient.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <Collabrify/Collabrify.h>
#import <Foundation/Foundation.h>

@class TextViewController;
@class SplashViewController;

@interface TextCollabrifyClient : NSObject

@property (nonatomic, retain) CollabrifyClient* client;
@property (nonatomic, retain) TextViewController *textViewController;
@property (nonatomic, retain) SplashViewController *splashViewController;

- (id)initWithViewController:(TextViewController *)text;

- (void)findSession;
@end
