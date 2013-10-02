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
    _globalTruthText = [NSMutableString stringWithString:@""];
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
    [self.currentEdit pushBack:[[TextAction alloc] initWithRange:range text:deletedText]];
  } else if (range.length > 0 && text.length > 0) {
    // This action is an autocomplete/correct. Split it up into a remove and an addition.
    NSString* deletedText = [textView.text substringWithRange:range];
    
    // pushBack on the remove.
    [self.currentEdit pushBack:[[TextAction alloc] initWithRange:range text:deletedText]];
    
    // Push on the add.
    [self.currentEdit pushBack:[[TextAction alloc] initWithRange:NSMakeRange(range.location, 0)
                                                             text:text]];
  } else {
    // This action is an add.
    [self.currentEdit pushBack:[[TextAction alloc] initWithRange:range text:text]];
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
  NSLog(@"text view did change selection, location: %d, length: %d", textView.selectedRange.location, textView.selectedRange.length);

  CursorAction *cursorAction = [[CursorAction alloc] initWithPosition:textView.selectedRange.location
                                                                 user:-1];
  
  if (selectionChangeFromInput || textView.selectedRange.location == lastSelectedLocation) {
    selectionChangeFromInput = NO;
    lastSelectedLocation = textView.selectedRange.location;
    return;
  } else if (self.currentEdit.size && [[self.currentEdit front] isKindOfClass:[TextAction class]]) {
    // There exists a current edit. Sync up with the server. Cancel any running timer.
    if (self.timer.isValid) {
      [self.timer invalidate];
    }
    
    [self mergeCurrentEdit];
  }
  
  // Start the timer again. This is the start of a new edit series.
  [self resetTimer];
  
  // Push cursor movement onto current edit. Bogus user since this is a local change - we'll set
  // the user right before we broadcast this series of actions.
  [self.currentEdit pushBack:cursorAction];
  
  lastSelectedLocation = textView.selectedRange.location;
}

- (void)mergeCurrentEdit {
  NSLog(@"Merge current Edit ***");
  
  if ([self.currentEdit empty]) {
    return;
  }
  
  // SEMAPHORE WAIT
  
  // First, merge individual edits (usually insert/remove a single char) into group edits.
  Deque *mergedEdits = [self mergeSingleEdits];
  
  // Debug print.
  //[self printQueue:mergedEdits];
  
  // Now, merge group add/delete sequences as much as possible.
  Deque *finalEdits = [self resolveMergedEdits:mergedEdits];
  
  // Debug print.
  //[self printQueue:finalEdits];
  
  // notify collab client of changes
  [[TextCollabrifyClient sharedClient] sendActionsAndSync:finalEdits];
}

// Merge a series of single edits (i.e. (INSERT, {0,0}, 'h'), (INSERT, {1,0}, 'i')) into a series of merged
// edits (i.e. (INSERT, {0,0}, 'hi')). However, this function makes no effort to resolve these 'merged
// edits' (i.e. (INSERT, {0,0}, 'here'), (DELETE, {2,2}, 're'), (INSERT, {2,0}, 'm') is NOT resolved to the
// single edit (INSERT, {0,0}, 'hem'), although it may be semantically correct to do so.
- (Deque *)mergeSingleEdits {
  id singleEdit;
  id currentMergedEdit;
  Deque *mergedEdits = [[Deque alloc] init];

  while ((singleEdit = [self.currentEdit popQueue])) {
    if ([singleEdit isKindOfClass:[CursorAction class]]) {
      [mergedEdits pushBack:singleEdit];
      currentMergedEdit = singleEdit;
      continue;
    }
    
    TextAction *singleTextEdit = singleEdit;
    if ([mergedEdits empty] ||
        [currentMergedEdit isKindOfClass:[CursorAction class]] ||
        singleTextEdit.editType != ((TextAction *)currentMergedEdit).editType) {
      // This is the first action or the actions are different.
      [mergedEdits pushBack:singleEdit];
      currentMergedEdit = singleEdit;
    } else {
      // The actions are of the same type. Merge them.
      TextAction *mergedTextEdit = currentMergedEdit;
      if (singleTextEdit.editType == REMOVE) {
        mergedTextEdit.range =
            NSMakeRange(singleTextEdit.range.location,
                        mergedTextEdit.range.length + singleTextEdit.range.length);
        
        mergedTextEdit.text = (mergedTextEdit.text) ?
            [singleTextEdit.text stringByAppendingString:mergedTextEdit.text] : singleTextEdit.text;
      } else if (singleTextEdit.editType == INSERT) {
        mergedTextEdit.text = (mergedTextEdit.text) ?
            [mergedTextEdit.text stringByAppendingString:singleTextEdit.text] : singleTextEdit.text;
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
  if (!mergedEdits || [mergedEdits empty]) {
    NSLog(@"resolveMergedEdits called with nil or empty edit deque");
    return nil;
  }
  
  Deque *finalEdits = [[Deque alloc] init];
  
  CursorAction *cursorMoved = nil;
  while ([[mergedEdits back] isKindOfClass:[CursorAction class]]) {
    // throw out mult. cursor moves in a row
    cursorMoved = [mergedEdits popQueue];
  }
  
  if (![mergedEdits empty]) {
    
    // Initialize invariants.
    TextAction *curAction = [mergedEdits popQueue];
    int smallestIndex, ogCursorIndex;
    smallestIndex = ogCursorIndex = curAction.range.location;
    
    [finalEdits pushBack:curAction];
    
    while ((curAction = [mergedEdits popQueue])) {
      TextAction* lastAction = [finalEdits front];
      
      if (curAction.editType == REMOVE) {
        if (curAction.range.location < smallestIndex) {
          int netDeletionLength = ogCursorIndex - curAction.range.location;
          curAction.range = NSMakeRange(curAction.range.location, netDeletionLength);
          
          // If there are delete sequences that overwrite each other, we need to keep track of the total
          // text deleted. We do this by appending the text removed by the last delete with the text removed
          // by the current delete.
          TextAction* ogDeleteAction = [finalEdits back];
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
          [finalEdits pushBack:curAction];
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
          [finalEdits pushBack:curAction];
          // TODO: Optimize, if they re-type the same shit.
        } else {
          lastAction.text = [lastAction.text stringByAppendingString:curAction.text];
        }
      }
    }
  }
  if(cursorMoved != nil) [finalEdits pushFront:cursorMoved];
  
  return finalEdits;
}

// We've received other people's changes. Insert them into the text view.
- (void)renderIncomingEdits:(NSNotification *)notification textView:(UITextView *)textView {
  NSLog(@"TIME TO RENDER THE NEW EVENTS");
  Deque *renderableEdits = [[notification userInfo] objectForKey:renderUpdatesDictName];
  
  @try {
    
    TextAction *action;
    while ((action = [renderableEdits popQueue])) {
      
      NSLog(@"text: %@, type: %@, location: %d, length: %d",
            action.text,
            (action.editType) ? @"REMOVE" : @"INSERT",
            action.range.location,
            action.range.length);
      
      int location = action.range.location;
      int length = action.range.length;
      if (action.editType == INSERT) {
        [self.globalTruthText insertString:action.text atIndex:location];
      } else {
        NSRange deletedCharactersRange = NSMakeRange(location - length, length);
        [self.globalTruthText deleteCharactersInRange:deletedCharactersRange];
      }
    }
      
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"calling dispatch async");
      [textView setText:[NSString stringWithString:self.globalTruthText]];

      TextCollabrifyClient *textClient = [TextCollabrifyClient sharedClient];
      NSNumber* user = [NSNumber numberWithInt:textClient.client.participantID];
      NSNumber* selfCursor = [textClient.userCursors objectForKey:user];
      
      // avoid cyclical cursor movement -> callback -> action loop.
      selectionChangeFromInput = YES;
      textView.selectedRange = NSMakeRange(selfCursor.intValue, 0);
      
      // SEMAPHORE SIGNAL
    });
      
  } @catch (NSException *exception) {
    NSLog(@" *** Exception thrown *** - \n %@", exception.reason);
    [[TextCollabrifyClient sharedClient] deleteSession];
    
    // SEMAPHORE SIGNAL
  }
}


#pragma mark -
#pragma mark Undo and Redo

- (void)undo:(UITextView *)textView {
  [self.timer invalidate];
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
  [self.redoStack pushBack:lastAction];
  selectionChangeFromInput = YES;
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
  [self.timer invalidate];
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
  [self.undoStack pushBack:undidAction];
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
    [deque pushBack:action];
  }
}

@end
