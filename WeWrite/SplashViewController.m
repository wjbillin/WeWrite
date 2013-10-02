//
//  SplashViewController.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "SplashViewController.h"
#import "TextCollabrifyClient.h"
#import "TextViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)init
{
  if (self = [super init]) {
      // Custom initialization.
    _joinButton = [[UIButton alloc] init];
    _spinny = [[UIActivityIndicatorView alloc] init];
    _textViewController = [[TextViewController alloc] init];
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor orangeColor]];
  
  self.joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.joinButton setFrame:CGRectMake(0, 0, 200, 50)];
  
  CGRect bounds = [self.view bounds];
  [self.joinButton setCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) - 30)];
  [self.joinButton setTitle:@"start" forState:UIControlStateNormal];
  [self.joinButton addTarget:self
                      action:@selector(joinSession)
            forControlEvents:UIControlEventTouchUpInside];

  
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  UILabel *title = [[UILabel alloc] initWithFrame:screen];
  [title setTextAlignment:NSTextAlignmentCenter];
  [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:64]];
  [title setText:@"Cœdit"];
  [title setCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) - 100)];
  title.backgroundColor = [UIColor clearColor];
  
  [self.view addSubview:title];
  [self.view addSubview:self.joinButton];
}

- (void)addSpinny {
  self.spinny.center = self.view.center;
  [self.view addSubview:self.spinny];
  [self.spinny startAnimating];
}

- (void)joinSession {
  [self addSpinny];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(joinedSession)
                                               name:@"SESSION_JOINED"
                                             object:nil];
  
  [[TextCollabrifyClient sharedClient] findSession];
}

- (void)joinedSession {
  [self.spinny stopAnimating];
  
  NSLog(@"Joined Session called");
  [self presentViewController:self.textViewController animated:YES completion:nil];
}

@end
