//
//  Deque.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Deque.h"

@implementation Deque

- (id)init {
  if (self = [super init]) {
    _array = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)clear {
  [self.array removeAllObjects];
}

- (BOOL)empty {
  return (self.array.count == 0);
}

- (id)front {
  return [self.array lastObject];
}

- (id)back {
  return (self.array.count > 0) ? [self.array objectAtIndex:0] : nil;
}

- (void)push:(id)object {
  [self.array addObject:object];
}

- (id)popStack {
  id lastObject = [self.array lastObject];
  if (lastObject) {
    [self.array removeObject:lastObject];
  }
  
  return lastObject;
}

- (id)popQueue {
  id firstObject = nil;
  
  if (self.array.count) {
    firstObject = [self.array objectAtIndex:0];
    [self.array removeObjectAtIndex:0];
  }
  
  return firstObject;
}

- (NSUInteger)size {
  return self.array.count;
}

@end
