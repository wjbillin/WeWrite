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
  DELETE
} EditType;

@interface TextAction : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) EditType editType;

- (id)init;
- (id)init:(TextAction *)action;
- (id)init:(NSRange)range text:(NSString *)text;
- (EditType)type:(NSRange)range;

@end