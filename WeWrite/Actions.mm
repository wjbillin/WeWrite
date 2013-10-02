//
//  TextAction.m
//  WeWrite
//
//  Created by Otto Sipe on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Actions.h"

@implementation CursorAction

- (id)init {
  if (self = [super init]) {
    _user = -1;
    _position = -1;
  }
  
  return self;
}

- (id)initWithPosition:(NSInteger)position user:(NSInteger)user {
  if (self = [super init]) {
    _user = user;
    _position = position;
  }
  
  return self;
}

@end

@implementation TextAction

- (id)init {
  if (self = [super init]) {
    return [self initWithRange:NSMakeRange(0, 0) text:nil];
  }
  
  return self;
}

- (id)initWithAction:(TextAction *)action {
  if (self = [super init]) {
    return [self initWithRange:action.range text:action.text];
  }
  
  return self;
}

- (id)initWithRange:(NSRange)range text:(NSString *)text {
  if (self = [super init]) {
    _user = -1;
    _range = range;
    _text = text;
    _editType = [self type:range];
    _isUndo = NO;
    _isRedo = NO;
  }
  return self;
}

- (id)initWithUser:(NSInteger)user text:(NSString *)text editType:(EditType)type {
  if (self = [super init]) {
    _user = user;
    _range = NSMakeRange(0, 0);
    _text = text;
    _editType = type;
    _isUndo = NO;
    _isRedo = NO;
  }
  
  return self;
}

- (EditType)type:(NSRange)range{
  return (range.length == 0) ? INSERT : REMOVE;
}

@end
