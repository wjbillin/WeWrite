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

- (id)frontQueue;
- (id)frontStack;
- (id)popQueue;
- (id)popStack;
- (void)push:(id)object;

@end
