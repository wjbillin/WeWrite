//
//  TextAction.h
//  WeWrite
//
//  Created by Otto Sipe on 9/21/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  INSERT,
  REMOVE,
  CURSOR
} EditType;

// A cursor move action. Mirrors the generated proto class CursorUpdate.
@interface CursorAction : NSObject

@property (nonatomic, assign) NSInteger user;
@property (nonatomic, assign) NSInteger position;

- (id)init;
- (id)initWithPosition:(NSInteger)position user:(NSInteger)user;

@end

// A text action performed by the local user.
@interface TextAction : NSObject

@property (nonatomic, assign) NSInteger user;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) EditType editType;

- (id)init;
- (id)initWithAction:(TextAction *)action;
- (id)initWithRange:(NSRange)range text:(NSString *)text;
- (id)initWithUser:(NSInteger)user text:(NSString *)text editType:(EditType)type;

- (EditType)type:(NSRange)range;

@end