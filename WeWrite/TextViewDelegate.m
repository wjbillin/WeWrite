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
    _timer = [[NSTimer alloc] init];
  }
  
  return self;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  
  NSLog(@"Delegate called, location: %d, length: %d, selected location: %d, text is [%@]",
        range.location,
        range.length,
        textView.selectedRange.location,
        text);
  
  // Reset timer.
  
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

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  NSLog(@"TextViewDidChange callback, selected position: %d", textView.selectedRange.location);
  
  TextAction *lastAction = [self.currentEdit frontStack];
  NSUInteger currentCursor = textView.selectedRange.location;
  
  if (lastAction && lastAction.range.length > 0 && currentCursor == (lastAction.range.location - 1)) {
    // This is an iOS bug - or at least VERY bad behavior. Take the sentence 'I like to work.'. If
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

- (void)mergeCurrentEdit {
  TextAction *singleAction  = [[TextAction alloc] init];
  TextAction *mergedAction = [[TextAction alloc] init];
  
  Deque *mergedActions = [[Deque alloc] init];
    
  while ((singleAction = [self.currentEdit popQueue])) {
    if ([mergedActions empty] || mergedAction.editType != singleAction.editType) {
      // This is the first action or the actions are different.
      [mergedActions push:singleAction];
      mergedAction = singleAction;
    } else {
      // The actions are of the same type. Merge them.
      if (singleAction.editType == DELETE) {
        mergedAction.range =
            NSMakeRange(singleAction.range.location, mergedAction.range.length + singleAction.range.length);
        mergedAction.text = (mergedAction.text) ?
            [singleAction.text stringByAppendingString:mergedAction.text] : singleAction.text;
      } else if (singleAction.editType == INSERT) {
        mergedAction.text = (mergedAction.text) ?
            [mergedAction.text stringByAppendingString:singleAction.text] : singleAction.text;
      }
    }
  }
  
  // Debug print.
  while ((mergedAction = [mergedActions popQueue])) {
    NSLog(@"Merged action entry: location: %d, length: %d, text: [%@]", mergedAction.range.location,
          mergedAction.range.length, mergedAction.text);
  }
  
  // Now, merge individual add/delete sequences as much as possible.
  int smallestIndex = ((TextAction *)[mergedActions frontQueue]).range.location;
  
}

#pragma mark -
#pragma mark Undo

- (void)undo:(UITextView *)textView {
  [self mergeCurrentEdit];
  
  /*
  TextAction *lastAction = [self.undoStack popStack];
  
  if (lastAction) {
    NSLog(@"Undoing last action, location: %d, length: %d, text: [%@]",
          lastAction.range.location,
          lastAction.range.length,
          lastAction.text);
    if (lastAction.range.length > 0) {
      [self undoRemove:lastAction text:textView.text];
    } else {
      [self undoAdd:lastAction text:textView.text];
    }
    [self.redoStack push:lastAction];
  }*/
}

- (void)undoAdd:(TextAction *)addAction text:(NSString *)text {
  text = [NSString stringWithFormat:@"%@%@",
          [text substringToIndex:addAction.range.location],
          [text substringFromIndex:(addAction.range.location + addAction.text.length)]];
}

- (void)undoRemove:(TextAction *)removeAction text:(NSString *)text {
  text = [NSString stringWithFormat:@"%@%@%@",
          [text substringToIndex:removeAction.range.location],
          removeAction.text,
          [text substringFromIndex:removeAction.range.location]];
}

- (void)redo:(UITextView *)textView {
  return;
}

@end
