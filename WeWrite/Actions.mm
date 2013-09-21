//
//  TextAction.m
//  WeWrite
//
//  Created by Otto Sipe on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Actions.h"

@implementation LocalTextAction

- (id)init {
  if (self = [super init]) {
    return [self initWithRange:NSMakeRange(0, 0) text:nil];
  }
  
  return self;
}

- (id)initWithAction:(LocalTextAction *)action {
  if (self = [super init]) {
    return [self initWithRange:action.range text:action.text];
  }
  
  return self;
}

- (id)initWithRange:(NSRange)range text:(NSString *)text {
  if (self = [super init]) {
    _range = range;
    _text = text;
    _editType = [self type:range];
  }
  return self;
}


- (EditType)type:(NSRange)range{
  return (range.length == 0) ? INSERT : REMOVE;
}

@end

@implementation ServerTextAction

- (id)initWithServerUpdate:(NSInteger)user text:(NSString *)text editType:(EditType)editType {
  if (self = [super init]) {
    _user = user;
    _text = [NSString stringWithString:text];
    _editType = editType;
  }
  
  return self;
}

@end

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
