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
    
    _undoButton = [[UIButton alloc] init];
    _redoButton = [[UIButton alloc] init];
  }
    
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [self setUpTextView];
  [self setUpButtons];
}

- (void)setUpButtons {
  self.undoButton.frame = CGRectMake(10, 10, 100, 30);
  [self.undoButton setTitle:@"Undo" forState:UIControlStateNormal];
  [self.undoButton addTarget:self
                      action:@selector(undo)
            forControlEvents:UIControlEventTouchUpInside];
  
  self.redoButton.frame = CGRectMake(170, 10, 100, 30);
  [self.redoButton setTitle:@"Redo" forState:UIControlStateNormal];
  [self.redoButton addTarget:self
                      action:@selector(redo)
            forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.undoButton];
  [self.view addSubview:self.redoButton];
}

- (void)setUpTextView {
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  [self.textView setFrame:CGRectMake(0,
                                     TOP_TOOLBAR_HEIGHT,
                                     screenSize.width,
                                     screenSize.height - TOP_TOOLBAR_HEIGHT)];
  [self.textView setDelegate:self.delegate];
  
  [self.view addSubview:self.textView];
}

- (void)undo {
  [self.delegate undo:self.textView];
}

- (void)redo {
  [self.delegate redo:self.textView];
}

@end
