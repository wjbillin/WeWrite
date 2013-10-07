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
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  self.joinButton = [UIButton buttonWithType:UIButtonTypeSystem];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect bounds = [self.view bounds];
  [self.joinButton setFrame:CGRectMake(0, 0, screen.size.width - 50, 50)];
  [self.joinButton setCenter:CGPointMake(CGRectGetMidX(bounds), screen.size.height - 50)];
  [self.joinButton setTitle:@"start" forState:UIControlStateNormal];
  [self.joinButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
  [self.joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.joinButton setBackgroundColor:[UIColor orangeColor] ];
  [self.joinButton addTarget:self
                      action:@selector(joinSession)
            forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *image = [UIImage imageNamed:@"logo.png"];
  UIImage *scaledImage =
  [UIImage imageWithCGImage:[image CGImage]
                      scale:(image.scale * 3.0)
                orientation:(image.imageOrientation)];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:scaledImage];
  
  [imageView setCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds) - 100)];
  
  [self.view addSubview:imageView];
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
  TextViewController *textViewController = [[TextViewController alloc] init];
  [self presentViewController:textViewController animated:YES completion:nil];
}

@end
