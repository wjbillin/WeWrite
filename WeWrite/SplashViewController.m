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
  
  NSLog(@"inside view did load");
  [self.joinButton setFrame:CGRectMake(40, 40, 100, 50)];
  [self.joinButton setTitle:@"Hello" forState:UIControlStateNormal];
  [self.joinButton addTarget:self
                      action:@selector(joinSession)
            forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:self.joinButton];
  // money
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
  
  [self.textViewController.collabrifyClient findSession];
}

- (void)joinedSession {
  [self.spinny stopAnimating];
  
  NSLog(@"Joined Session called");
  [self presentViewController:self.textViewController animated:YES completion:nil];
}

@end
