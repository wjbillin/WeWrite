//
//  BaseViewController.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/11/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewDelegate.h"

#define TOP_TOOLBAR_HEIGHT 50

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)init {
    
  if (self = [super init]) {
    _textView = [[UITextView alloc] init];
    _delegate = [[TextViewDelegate alloc] init];
  }
    
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [self setUpTextView];
  [self.view addSubview:self.textView];
}

- (void)setUpTextView {
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  [self.textView setFrame:CGRectMake(0,
                                     TOP_TOOLBAR_HEIGHT,
                                     screenSize.width,
                                     screenSize.height - TOP_TOOLBAR_HEIGHT)];
  [self.textView setDelegate:self.delegate];
  
  NSLog(@"Hi, screen width is %f and height is %f", screenSize.width, screenSize.height);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
