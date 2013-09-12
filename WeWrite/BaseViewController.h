//
//  BaseViewController.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/11/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewDelegate;
@interface BaseViewController : UIViewController {
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) TextViewDelegate *delegate;

@end
