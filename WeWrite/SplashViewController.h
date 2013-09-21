//
//  SplashViewController.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewController;
@interface SplashViewController : UIViewController

@property (nonatomic, retain) TextViewController* textViewController;
@property (nonatomic, retain) UIActivityIndicatorView* spinny;
@property (nonatomic, retain) UIButton* joinButton;


@end
