//
//  TextViewDelegate.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deque;
@interface TextViewDelegate : NSObject<UITextViewDelegate> {
  // No explicit member variables. Properties.
}

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, retain) Deque *redoStack;
@property (nonatomic, retain) Deque *undoStack;
@property (nonatomic, retain) Deque *currentEdit;
@property (nonatomic, retain) NSTimer *timer;

- (void)undo:(UITextView *)textView;
- (void)redo:(UITextView *)textView;

@end