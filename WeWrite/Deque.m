//
//  Deque.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Deque.h"

@implementation Deque

+ (Deque *)dequeWithDeque:(Deque *)dequeCopy {
  Deque* returnDeque = [[Deque alloc] init];
  returnDeque.array = [NSMutableArray arrayWithArray:dequeCopy.array];
  
  return returnDeque;
}

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

- (id)back {
  return [self.array lastObject];
}

- (id)front {
  return (self.array.count > 0) ? [self.array objectAtIndex:0] : nil;
}

- (void)pushBack:(id)object {
  [self.array addObject:object];
}

- (void)pushFront:(id)object {
  if (self.array.count) {
    [self.array insertObject:object atIndex:0];
  } else {
    [self.array addObject:object];
  }
}

- (id)popBack {
  id lastObject = [self.array lastObject];
  if (lastObject) {
    [self.array removeObject:lastObject];
  }
  
  return lastObject;
}

- (id)popFront {
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
