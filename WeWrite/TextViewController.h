//
//  TextViewController.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/11/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewDelegate;
@interface TextViewController : UIViewController {
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) TextViewDelegate *delegate;
@property (nonatomic, retain) UIButton *undoButton;
@property (nonatomic, retain) UIButton *redoButton;
@property (nonatomic, retain) UIButton *exitButton;

@end
