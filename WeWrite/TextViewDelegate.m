//
//  TextViewDelegate.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Deque.h"
#import "TextViewDelegate.h"

typedef enum {
  INSERT,
  DELETE
} EditType;

@interface TextAction : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) EditType editType;

@end

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
  return (range.length == 0) ? INSERT : DELETE;
}

@end

@interface TextViewDelegate ()

@end

@implementation TextViewDelegate

- (id)init {
  if (self = [super init]) {
    _count = 0;
    _redoStack = [[Deque alloc] init];
    _undoStack = [[Deque alloc] init];
    _currentEdit = [[Deque alloc] init];
  }
  
  return self;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  
  /*NSLog(@"Delegate called, location: %d, length: %d, selected location: %d, text is [%@]",
        range.location,
        range.length,
        textView.selectedRange.location,
        text);*/
  
  if (range.location == 0 && range.length == 0 && text.length == 0) {
    // User is backspacing at the beginning of the document. Don't bother recording anything.
    return YES;
  }
  
  if (range.length > 0 && text.length == 0) {
    // This action is a delete. Find out what characters were deleted.
    NSString *deletedText = [textView.text substringWithRange:range];
    [self.currentEdit push:[[TextAction alloc] init:range text:deletedText]];
  } else if (range.length > 0 && text.length > 0) {
    // This action is an autocomplete/correct. Split it up into a remove and an addition.
    NSString* deletedText = [textView.text substringWithRange:range];
    
    // Push on the remove.
    [self.currentEdit push:[[TextAction alloc] init:range text:deletedText]];
    
    // Push on the add.
    [self.currentEdit push:[[TextAction alloc] init:NSMakeRange(range.location, 0) text:text]];
  } else {
    // This action is an add.
    [self.currentEdit push:[[TextAction alloc] init:range text:text]];
  }
  
  // If the timer is currently running, we want to stop it before scheduling it again.
  [self resetTimer];
  
  // Clear the redo stack if we're editing.
  [self.redoStack clear];

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  //NSLog(@"TextViewDidChange callback, selected position: %d", textView.selectedRange.location);
  
  TextAction *lastAction = [self.currentEdit front];
  NSUInteger currentCursor = textView.selectedRange.location;
  
  if (lastAction && lastAction.range.length > 0 && currentCursor == (lastAction.range.location - 1)) {
    // This is an iOS 6 bug - or at least VERY bad behavior. Take the sentence 'I like to work.'. If
    // you select 'to' and press backspace, iOS decides to delete 'to' as well as the space preceding
    // 'to', WITHOUT giving us any indication that it has done this. Making it even worse, sometimes
    // it does NOT delete the space before 'to' (if you select 'to', click and hold on left blue selection
    // marker but DO NOT change the position of the marker, and then press delete). Bullshit. Luckily,
    // we can use this callback (in which the deletion action has just been applied to the text view),
    // and examine the position of the cursor to determine if the space was wiped out or not.
    
    // TODO(wjbillin): Can we really assume that the cursor will only differ by one? Can we assume that
    // the character that was silently deleted was a space?
    
    lastAction.range = NSMakeRange(lastAction.range.location - 1, lastAction.range.length + 1);
    lastAction.text = [@" " stringByAppendingString:lastAction.text];
    
    NSLog(@"New last action is: location: %d, length: %d, text: [%@]",
          lastAction.range.location,
          lastAction.range.length,
          lastAction.text);
  }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
  // User has moved their cursor. Merge any pending edits.
  if (self.timer && self.timer.isValid) {
    [self.timer invalidate];
  }
  [self mergeCurrentEdit];
}

- (void)mergeCurrentEdit {
  // First, merge individual edits (usually insert/remove a single char) into group edits.
  Deque *mergedEdits = [self mergeSingleEdits];
  
  // Debug print.
  [self printQueue:mergedEdits];
  
  if ([mergedEdits empty]) {
    return;
  }
  
  // Now, merge group add/delete sequences as much as possible.
  Deque *finalEdits = [self resolveMergedEdits:mergedEdits];
  
  // Debug print.
  [self printQueue:finalEdits];
  
  // Put the actions in the undo stack.
  TextAction *curAction;
  while ((curAction = [finalEdits popQueue])) {
    [self.undoStack push:curAction];
  }
}

// Merge a series of single edits (i.e. (INSERT, {0,0}, 'h'), (INSERT, {1,0}, 'i')) into a series of merged
// edits (i.e. (INSERT, {0,0}, 'hi')). However, this function makes no effort to resolve these 'merged
// edits' (i.e. (INSERT, {0,0}, 'here'), (DELETE, {2,2}, 're'), (INSERT, {2,0}, 'm') is NOT resolved to the
// single edit (INSERT, {0,0}, 'hem'), although it is semantically correct to do so. For that functionality,
// please see resolveMergedEdits.
- (Deque *)mergeSingleEdits {
  TextAction *singleEdit;
  TextAction *currentMergedEdit;
  Deque *mergedEdits = [[Deque alloc] init];

  while ((singleEdit = [self.currentEdit popQueue])) {
    if ([mergedEdits empty] || currentMergedEdit.editType != singleEdit.editType) {
      // This is the first action or the actions are different.
      [mergedEdits push:singleEdit];
      currentMergedEdit = singleEdit;
    } else {
      // The actions are of the same type. Merge them.
      if (singleEdit.editType == DELETE) {
        currentMergedEdit.range = NSMakeRange(singleEdit.range.location,
                                              currentMergedEdit.range.length + singleEdit.range.length);
        currentMergedEdit.text = (currentMergedEdit.text) ?
            [singleEdit.text stringByAppendingString:currentMergedEdit.text] : singleEdit.text;
      } else if (singleEdit.editType == INSERT) {
        currentMergedEdit.text = (currentMergedEdit.text) ?
            [currentMergedEdit.text stringByAppendingString:singleEdit.text] : singleEdit.text;
      }
    }
  }
  
  return mergedEdits;
}

// Resolve the merged edits (add/removal group edits) into the minimum number of actions that correctly
// represent the edits made.
//
// Let's look at a high-level example: if mergedEdits is {(INSERT, {0,0}, 'hello'), (DELETE, {2,3}, 'llo'),
// (INSERT, {2, 0}, ' likes to eat')}, then this function will resolve mergedEdits into a deque with a
// single action - {(INSERT, {0,0}, 'he likes to eat')}.
- (Deque *)resolveMergedEdits:(Deque *)mergedEdits {
  Deque *finalEdits = [[Deque alloc] init];
  
  TextAction *lastAction = [mergedEdits back];
  int smallestIndex, ogCursorIndex;
  smallestIndex = ogCursorIndex = lastAction.range.location;
  NSLog(@"smallest index is %d", smallestIndex);
  
  TextAction *curAction = [mergedEdits popQueue];
  [finalEdits push:curAction];
  
  while ((curAction = [mergedEdits popQueue])) {
    TextAction* lastAction = [finalEdits front];
    
    if (curAction.editType == DELETE) {
      if (curAction.range.location < smallestIndex) {
        int netDeletionLength = ogCursorIndex - curAction.range.location;
        curAction.range = NSMakeRange(curAction.range.location, netDeletionLength);
        
        TextAction* ogDeleteAction = [finalEdits back];
        if (ogDeleteAction.editType == DELETE && ogDeleteAction != curAction) {
          NSLog(@"Smallest index is %d and curAction location is %d", smallestIndex, curAction.range.location);
          curAction.text =
          [NSString stringWithFormat:@"%@%@",
           [curAction.text substringToIndex:(smallestIndex - curAction.range.location)],
           ogDeleteAction.text];
          
          curAction.range = NSMakeRange(curAction.range.location, curAction.text.length);
        } else {
          curAction.text = [curAction.text substringToIndex:ogCursorIndex - curAction.range.location];
        }
        
        [finalEdits clear];
        [finalEdits push:curAction];
        smallestIndex = curAction.range.location;
      } else {
        lastAction.text =
        [lastAction.text substringToIndex:(lastAction.text.length - curAction.range.length)];
        
        if (!lastAction.text.length) {
          // We've clobbered the entire insertion directly before this removal.
          [finalEdits popStack];
        }
      }
    } else if (curAction.editType == INSERT) {
      if (!lastAction || lastAction.editType == DELETE) {
        [finalEdits push:curAction];
        if(lastAction && [lastAction.text isEqualToString:curAction.text]) {
          [finalEdits popStack];
        }
      } else {
        lastAction.text = [lastAction.text stringByAppendingString:curAction.text];
      }
    }
  }
  
  return finalEdits;
}

#pragma mark -
#pragma mark Undo and Redo

- (void)undo:(UITextView *)textView {
  [self resetTimer];
  [self mergeCurrentEdit];

  TextAction *lastAction = [self.undoStack popStack];
  if (!lastAction) {
    return;
  }
  
  NSLog(@"Undoing last action, location: %d, length: %d, text: [%@]",
        lastAction.range.location,
        lastAction.range.length,
        lastAction.text);
  if (lastAction.range.length > 0) {
    [self undoRemove:lastAction textView:textView];
  } else {
    [self undoAdd:lastAction textView:textView];
  }
  [self.redoStack push:lastAction];
}

- (void)undoAdd:(TextAction *)addAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@",
                   [textView.text substringToIndex:addAction.range.location],
                   [textView.text substringFromIndex:(addAction.range.location + addAction.text.length)]];
}

- (void)undoRemove:(TextAction *)removeAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@%@",
                   [textView.text substringToIndex:removeAction.range.location],
                   removeAction.text,
                   [textView.text substringFromIndex:removeAction.range.location]];
}

- (void)redo:(UITextView *)textView {
  [self resetTimer];
  [self mergeCurrentEdit];

  TextAction *undidAction = [self.redoStack popStack];
  if (!undidAction) {
    return;
  }
  
  NSLog(@"Redoing action, location: %d, length: %d, text: [%@]",
        undidAction.range.location,
        undidAction.range.length,
        undidAction.text);
  if (undidAction.range.length > 0) {
    [self redoRemove:undidAction textView:textView];
  } else {
    [self redoAdd:undidAction textView:textView];
  }
  [self.undoStack push:undidAction];
}

- (void)redoAdd:(TextAction *)textAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@%@",
                   [textView.text substringToIndex:textAction.range.location],
                   textAction.text,
                   [textView.text substringFromIndex:textAction.range.location]];
}

- (void)redoRemove:(TextAction *)textAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@",
                   [textView.text substringToIndex:textAction.range.location],
                   [textView.text substringFromIndex:(textAction.range.location +
                                                      textAction.range.length)]];
}

- (void)resetTimer {
  if (self.timer && self.timer.isValid) {
    [self.timer invalidate];
  }
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(mergeCurrentEdit)
                                              userInfo:nil
                                               repeats:NO];
}

#pragma mark -
#pragma mark Utility

- (void)printQueue:(Deque *)deque {
  TextAction *action;
  int count = 0;
  int size = [deque size];
  
  while (count++ < size) {
    action = [deque popQueue];
    NSLog(@"Queue entry: location: %d, length: %d, text: [%@]",
          action.range.location,
          action.range.length,
          action.text);
    [deque push:action];
  }
}

@end