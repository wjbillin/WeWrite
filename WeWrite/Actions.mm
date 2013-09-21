//
//  TextAction.m
//  WeWrite
//
//  Created by Otto Sipe on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Actions.h"
#import "froto/text.pb.h"

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

- (id)initWithServerUpdate:(TextUpdate *)textUpdate {
  if (self = [super init]) {
    _user = textUpdate->user();
    _text = [NSString stringWithCString:textUpdate->text().c_str()
                               encoding:[NSString defaultCStringEncoding]];
    _editType = (textUpdate->type() == TextUpdate_ChangeType::TextUpdate_ChangeType_INSERT)
        ? INSERT : REMOVE;
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

- (id)initWithServerUpdate:(CursorUpdate *)cursorUpdate {
  if (self = [super init]) {
    _user = cursorUpdate->user();
    _position = cursorUpdate->position();
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
