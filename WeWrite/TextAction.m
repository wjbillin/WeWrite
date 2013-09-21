//
//  TextAction.m
//  WeWrite
//
//  Created by Otto Sipe on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "TextAction.h"

@implementation TextAction

- (id)init {
  if (self = [super init]) {
    return [self init:NSMakeRange(0, 0) text:nil];
  }
  
  return self;
}

- (id)init:(TextAction *)action {
  if (self = [super init]) {
    return [self init:action.range text:action.text];
  }
  
  return self;
}

- (id)init:(NSRange)range text:(NSString *)text {
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
