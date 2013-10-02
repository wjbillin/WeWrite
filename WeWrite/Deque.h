//
//  Deque.h
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deque : NSObject

@property (nonatomic, retain) NSMutableArray *array;

- (void)clear;
- (BOOL)empty;
- (id)front;
- (id)back;
- (id)popQueue;
- (id)popStack;
- (void)pushBack:(id)object;
- (void)pushFront:(id)object;
- (NSUInteger)size;

@end
