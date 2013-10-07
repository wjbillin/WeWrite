//
//  TextViewController.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/11/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Constants.h"
#import "TextViewController.h"
#import "TextViewDelegate.h"
#import "TextCollabrifyClient.h"

#define TOP_TOOLBAR_HEIGHT 50
#define BUTTON_HEIGHT 20
#define BUTTON_WIDTH 50

@interface TextViewController ()

@end

@implementation TextViewController

- (id)init {
    
  if (self = [super init]) {
    _textView = [[UITextView alloc] init];
    _delegate = [[TextViewDelegate alloc] init];
    
    _undoButton = [[UIButton alloc] init];
    _redoButton = [[UIButton alloc] init];
    _exitButton = [[UIButton alloc] init];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(renderIncomingEdits:)
                                               name:renderUpdatesNotificationName
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(endedSession)
                                               name:endedSessionNotificationName
                                             object:nil];
  
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [self.view setBackgroundColor:[UIColor orangeColor]];
  [self setUpButtons];
  [self setUpTextView];
}

- (void)setUpButtons {
  
  CGFloat width = [[UIScreen mainScreen] bounds].size.width;
  CGRect rect = CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
  self.undoButton.frame = rect;
  
  [self.undoButton setCenter:CGPointMake(width/5, TOP_TOOLBAR_HEIGHT/1.5)];
  [self.undoButton setTitle:@"undo" forState:UIControlStateNormal];
  [self.undoButton.titleLabel setFont:font];
  [self.undoButton addTarget:self
                      action:@selector(undo)
            forControlEvents:UIControlEventTouchUpInside];
  
  self.redoButton.frame = rect;
  [self.redoButton setCenter:CGPointMake(width/2, TOP_TOOLBAR_HEIGHT/1.5)];
  [self.redoButton setTitle:@"redo" forState:UIControlStateNormal];
  [self.redoButton.titleLabel setFont:font];
  [self.redoButton addTarget:self
                      action:@selector(redo)
            forControlEvents:UIControlEventTouchUpInside];
  
  self.exitButton.frame = rect;
  [self.exitButton setCenter:CGPointMake(width/5*4, TOP_TOOLBAR_HEIGHT/1.5)];
  [self.exitButton setTitle:@"exit" forState:UIControlStateNormal];
  [self.exitButton.titleLabel setFont:font];
  [self.exitButton addTarget:self
                      action:@selector(exit)
            forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.undoButton];
  [self.view addSubview:self.redoButton];
  [self.view addSubview:self.exitButton];
}

- (void)setUpTextView {
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
  [self.textView setFont:[UIFont fontWithName:@"Courier New" size:12]];
  [self.textView setFrame:CGRectMake(0,
                                     TOP_TOOLBAR_HEIGHT,
                                     screenSize.width,
                                     screenSize.height - TOP_TOOLBAR_HEIGHT)];
  [self.textView setDelegate:self.delegate];
  
  [self.view addSubview:self.textView];
}

- (void)renderIncomingEdits:(NSNotification *)notification {
  [self.delegate renderIncomingEdits:notification textView:self.textView];
}

- (void)undo {
  [self.delegate undo];
}

- (void)redo {
  [self.delegate redo];
}

- (void)exit {
  [[TextCollabrifyClient sharedClient] deleteSession];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)endedSession {
  NSString *alertMessage = @"Sorry, the creator of this document has ended the session!";
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ended Session"
                                                      message:alertMessage
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil, nil];
  [alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if ([alertView.title isEqualToString:@"Ended Session"]) {
    [self exit];
  }
}

@end
