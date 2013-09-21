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
  REMOVE
} EditType;

// A text action performed by the local user.
@interface LocalTextAction : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) EditType editType;

- (id)init;
- (id)initWithAction:(LocalTextAction *)action;
- (id)initWithRange:(NSRange)range text:(NSString *)text;

- (EditType)type:(NSRange)range;

@end

// A text action performed by a remote user. Mirrors the generated proto class TextUpdate.
@interface ServerTextAction : NSObject

@property (nonatomic, assign) NSInteger user;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, assign) EditType editType;

- (id)initWithServerUpdate:(NSInteger)user text:(NSString *)text editType:(EditType)editType;

@end

// A cursor move action. Mirrors the generated proto class CursorUpdate.
@interface CursorAction : NSObject

@property (nonatomic, assign) NSInteger user;
@property (nonatomic, assign) NSInteger position;

- (id)init;
- (id)initWithPosition:(NSInteger)position user:(NSInteger)user;

@end