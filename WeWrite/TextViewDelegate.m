//
//  TextViewDelegate.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Actions.h"
#import "Constants.h"
#import "Deque.h"
#import "TextCollabrifyClient.h"
#import "TextViewDelegate.h"

BOOL selectionChangeFromInput = NO;
int lastSelectedLocation = 0;

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
    _globalTruthText = @"";
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
    [self.currentEdit push:[[LocalTextAction alloc] initWithRange:range text:deletedText]];
  } else if (range.length > 0 && text.length > 0) {
    // This action is an autocomplete/correct. Split it up into a remove and an addition.
    NSString* deletedText = [textView.text substringWithRange:range];
    
    // Push on the remove.
    [self.currentEdit push:[[LocalTextAction alloc] initWithRange:range text:deletedText]];
    
    // Push on the add.
    [self.currentEdit push:[[LocalTextAction alloc] initWithRange:NSMakeRange(range.location, 0)
                                                             text:text]];
  } else {
    // This action is an add.
    [self.currentEdit push:[[LocalTextAction alloc] initWithRange:range text:text]];
  }
  
  // If the timer is currently running, we want to stop it before scheduling it again.
  [self resetTimer];
  
  if ([[UIDevice currentDevice] systemVersion].intValue > 6) {
    NSLog(@"changing selection from input to YES");
    selectionChangeFromInput = YES;
  }
  
  // Clear the redo stack if we're editing.
  [self.redoStack clear];

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  //NSLog(@"TextViewDidChange callback, selected position: %d", textView.selectedRange.location);
  
  LocalTextAction *lastAction = [self.currentEdit front];
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
  NSLog(@"text view did change selection, location: %d, length: %d", textView.selectedRange.location, textView.selectedRange.length);

  if (selectionChangeFromInput || textView.selectedRange.location == lastSelectedLocation) {
    selectionChangeFromInput = NO;
  } else {
    NSLog(@"invalidating timer from cursor change");
    
    // This broadcasts right away. See if we can't send this as part of the same move as the built
    // up text actions.
    [[TextCollabrifyClient sharedClient] sendCursorMove:textView.selectedRange.location];
  
    if (self.timer.isValid) {
      [self.timer invalidate];
    }
    [self mergeCurrentEdit];
  }
  
  lastSelectedLocation = textView.selectedRange.location;
}

- (void)mergeCurrentEdit {
  NSLog(@"Merge current Edit ***");
  
  if ([self.currentEdit empty]) {
    return;
  }
  
  // First, merge individual edits (usually insert/remove a single char) into group edits.
  Deque *mergedEdits = [self mergeSingleEdits];
  
  // Debug print.
  [self printQueue:mergedEdits];
  
  // Now, merge group add/delete sequences as much as possible.
  Deque *finalEdits = [self resolveMergedEdits:mergedEdits];
  
  // Debug print.
  [self printQueue:finalEdits];
  
  // Deque to pass to collab client
  Deque *editsForCollab = [[Deque alloc] init];
  
  // Put the actions in the undo stack.
  LocalTextAction *curAction;
  while ((curAction = [finalEdits popQueue])) {
    [self.undoStack push:curAction];
    [editsForCollab push:curAction];
  }
  
  // notify collab client of changes
  [[TextCollabrifyClient sharedClient] sendTextActions:editsForCollab];
}

// Merge a series of single edits (i.e. (INSERT, {0,0}, 'h'), (INSERT, {1,0}, 'i')) into a series of merged
// edits (i.e. (INSERT, {0,0}, 'hi')). However, this function makes no effort to resolve these 'merged
// edits' (i.e. (INSERT, {0,0}, 'here'), (DELETE, {2,2}, 're'), (INSERT, {2,0}, 'm') is NOT resolved to the
// single edit (INSERT, {0,0}, 'hem'), although it is semantically correct to do so. For thatfunctionality,
// please see resolveMergedEdits.
- (Deque *)mergeSingleEdits {
  LocalTextAction *singleEdit;
  LocalTextAction *currentMergedEdit;
  Deque *mergedEdits = [[Deque alloc] init];

  while ((singleEdit = [self.currentEdit popQueue])) {
    if ([mergedEdits empty] || currentMergedEdit.editType != singleEdit.editType) {
      // This is the first action or the actions are different.
      [mergedEdits push:singleEdit];
      currentMergedEdit = singleEdit;
    } else {
      // The actions are of the same type. Merge them.
      if (singleEdit.editType == REMOVE) {
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
  
  LocalTextAction *lastAction = [mergedEdits back];
  int smallestIndex, ogCursorIndex;
  smallestIndex = ogCursorIndex = lastAction.range.location;
  //NSLog(@"smallest index is %d", smallestIndex);
  
  LocalTextAction *curAction = [mergedEdits popQueue];
  [finalEdits push:curAction];
  
  while ((curAction = [mergedEdits popQueue])) {
    LocalTextAction* lastAction = [finalEdits front];
    
    if (curAction.editType == REMOVE) {
      if (curAction.range.location < smallestIndex) {
        int netDeletionLength = ogCursorIndex - curAction.range.location;
        curAction.range = NSMakeRange(curAction.range.location, netDeletionLength);
        
        LocalTextAction* ogDeleteAction = [finalEdits back];
        if (ogDeleteAction.editType == REMOVE && ogDeleteAction != curAction) {
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
      if (!lastAction || lastAction.editType == REMOVE) {
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

// We've received other people's changes. Insert them into the text view.
- (void)renderIncomingEdits:(NSNotification *)notification textView:(UITextView *)textView {
  NSLog(@"TIME TO RENDER THE NEW EVENTS");
  Deque *incomingEdits = [[notification userInfo] objectForKey:renderTextEditsDictName];
  
  @try {
    
  LocalTextAction *action;
  while ((action = [incomingEdits popQueue])) {
    NSLog(@"text: %@, type: %@, location: %d, length: %d",
          action.text,
          (action.editType) ? @"REMOVE" : @"INSERT",
          action.range.location,
          action.range.length);
    
    int location = action.range.location;
    int length = action.range.length;
    if (action.editType == INSERT) {
      self.globalTruthText = [NSString stringWithFormat:@"%@%@%@",
                              [self.globalTruthText substringToIndex:location],
                              action.text,
                              [self.globalTruthText substringFromIndex:location]];
    } else {
      self.globalTruthText = [NSString stringWithFormat:@"%@%@",
                              [self.globalTruthText substringToIndex:(location - length)],
                              [self.globalTruthText substringFromIndex:location]];
    }
  }
    
  dispatch_async(dispatch_get_main_queue(), ^{
    [textView setText:self.globalTruthText];

    TextCollabrifyClient *textClient = [TextCollabrifyClient sharedClient];
    NSNumber* user = [NSNumber numberWithInt:textClient.client.participantID];
    NSNumber* selfCursor = [textClient.userCursors objectForKey:user];
    
    // Make sure to set this boolean so we don't have a cyclical cursor movement -> callback -> action
    // loop.
    selectionChangeFromInput = YES;
    textView.selectedRange = NSMakeRange(selfCursor.intValue, 0);
  });
    
  } @catch (NSException *exception) {
    NSLog(@" *** Exception thrown *** - \n %@", exception.reason);
    [[TextCollabrifyClient sharedClient] deleteSession];
  }
}


#pragma mark -
#pragma mark Undo and Redo

- (void)undo:(UITextView *)textView {
  [self.timer invalidate];
  [self mergeCurrentEdit];

  LocalTextAction *lastAction = [self.undoStack popStack];
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
  selectionChangeFromInput = YES;
}

- (void)undoAdd:(LocalTextAction *)addAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@",
                   [textView.text substringToIndex:addAction.range.location],
                   [textView.text substringFromIndex:(addAction.range.location + addAction.text.length)]];
}

- (void)undoRemove:(LocalTextAction *)removeAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@%@",
                   [textView.text substringToIndex:removeAction.range.location],
                   removeAction.text,
                   [textView.text substringFromIndex:removeAction.range.location]];
}

- (void)redo:(UITextView *)textView {
  [self.timer invalidate];
  [self mergeCurrentEdit];

  LocalTextAction *undidAction = [self.redoStack popStack];
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

- (void)redoAdd:(LocalTextAction *)LocalTextAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@%@",
                   [textView.text substringToIndex:LocalTextAction.range.location],
                   LocalTextAction.text,
                   [textView.text substringFromIndex:LocalTextAction.range.location]];
}

- (void)redoRemove:(LocalTextAction *)LocalTextAction textView:(UITextView *)textView {
  textView.text = [NSString stringWithFormat:@"%@%@",
                   [textView.text substringToIndex:LocalTextAction.range.location],
                   [textView.text substringFromIndex:(LocalTextAction.range.location +
                                                      LocalTextAction.range.length)]];
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
  LocalTextAction *action;
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
