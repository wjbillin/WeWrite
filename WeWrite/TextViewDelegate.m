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

BOOL cursorChangeFromInput = NO;
BOOL textChangeFromInput = NO;
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
    _userCursors = [[NSMutableDictionary alloc] init];
  }

  return self;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  
  if (textChangeFromInput) {
    // On iOS 7, this callback is fired for programatic text inserts. On iOS 6, it is not.
    // Kindly f**k yourself, Apple.
    NSLog(@"throwing out text change notification");
    return YES;
  }
  
  NSLog(@"Delegate called, location: %d, length: %d, selected location: %d, text is [%@]",
        range.location,
        range.length,
        textView.selectedRange.location,
        text);
  
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
    NSLog(@"changing cursor from input to YES");
    cursorChangeFromInput = YES;
  }
  
  // Clear the redo stack if we're editing.
  [self.redoStack clear];

  return YES;
}

/*- (void)textViewDidChange:(UITextView *)textView {
  //NSLog(@"TextViewDidChange callback, selected position: %d", textView.selectedRange.location);
  
  TextAction *lastAction = [self.currentEdit back];
  NSUInteger currentCursor = textView.selectedRange.location;
  
  if (lastAction && lastAction.range.length > 0 && currentCursor == (lastAction.range.location - 1)) {
    // This is an iOS 6 bug - or at least VERY bad behavior. Take the sentence 'I like to work.'. If
    // you select 'to' and press backspace, iOS decides to delete 'to' as well as the space preceding
    // 'to', WITHOUT giving us any indication that it has done this. Making it even worse, sometimes
    // it does NOT delete the space before 'to' (if you select 'to', click and hold on left blue selection
    // marker but DO NOT change the position of the marker, and then press delete). Bull. Luckily,
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
}*/

- (void)textViewDidChangeSelection:(UITextView *)textView {
  NSLog(@"text view did change selection, location: %d, length: %d", textView.selectedRange.location, textView.selectedRange.length);

  CursorAction *cursorAction = [[CursorAction alloc] initWithPosition:textView.selectedRange.location
                                                                 user:-1];
  if (cursorChangeFromInput ||
      textView.selectedRange.location == lastSelectedLocation ||
      textView.selectedRange.location > 100000000) {
    // For some reason iOS likes to send a HUGE number as the selected range location on the first
    // click in the text view.
    NSLog(@"throwing out cursor movement");
    cursorChangeFromInput = NO;
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
  [[TextCollabrifyClient sharedClient] sendActions:finalEdits];
}

// Merge a series of single edits (i.e. (INSERT, {0,0}, 'h'), (INSERT, {1,0}, 'i')) into a series of merged
// edits (i.e. (INSERT, {0,0}, 'hi')). However, this function makes no effort to resolve these 'merged
// edits' (i.e. (INSERT, {0,0}, 'here'), (DELETE, {2,2}, 're'), (INSERT, {2,0}, 'm') is NOT resolved to the
// single edit (INSERT, {0,0}, 'hem'), although it may be semantically correct to do so.
- (Deque *)mergeSingleEdits {
  id singleEdit;
  id currentMergedEdit;
  Deque *mergedEdits = [[Deque alloc] init];

  while ((singleEdit = [self.currentEdit popFront])) {
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
    cursorMoved = [mergedEdits popFront];
  }
  
  if (![mergedEdits empty]) {
    
    // Initialize invariants.
    TextAction *curAction = [mergedEdits popFront];
    int smallestIndex, ogCursorIndex;
    smallestIndex = ogCursorIndex = curAction.range.location;
    
    [finalEdits pushBack:curAction];
    
    while ((curAction = [mergedEdits popFront])) {
      TextAction* lastAction = [finalEdits back];
      
      if (curAction.editType == REMOVE) {
        if (curAction.range.location < smallestIndex) {
          int netDeletionLength = ogCursorIndex - curAction.range.location;
          curAction.range = NSMakeRange(curAction.range.location, netDeletionLength);
          
          // If there are delete sequences that overwrite each other, we need to keep track of the total
          // text deleted. We do this by appending the text removed by the last delete with the text
          // removed by the current delete.
          TextAction* ogDeleteAction = [finalEdits front];
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
            [finalEdits popBack];
          }
        }
      } else if (curAction.editType == INSERT) {
        if (!lastAction || lastAction.editType == REMOVE) {
          [finalEdits pushBack:curAction];
          // TODO: Optimize, if they re-type the same crap.
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
    
    id action;
    while ((action = [renderableEdits popFront])) {
      if([action isKindOfClass:CursorAction.class]) {
        // This is a cursor movement.
        CursorAction *cursorAction = action;
        
        [self.userCursors setObject:[NSNumber numberWithInt:cursorAction.position]
                             forKey:[NSNumber numberWithInt:cursorAction.user]];
      } else {
        // Text action. Figure out the location/length of this text edit.
        TextAction *textAction = action;
        NSNumber *user = [NSNumber numberWithInteger:textAction.user];
        NSNumber *loc = [self.userCursors objectForKey:user];
        int cursorBasedLocation = loc.intValue;
        int length = (textAction.editType == REMOVE) ? textAction.text.length : 0;
        
        // Only set the range on this edit (based on our view of the cursors) if it is NOT an undo/redo,
        // since undo/redo's carry their own location.
        if (!textAction.isUndo && !textAction.isRedo) {
          textAction.range = NSMakeRange(cursorBasedLocation, length);
        } else {
          // This is an undo/redo. The location has already been set, but the length is zero.
          // Fix this for removes.
          if (textAction.editType == REMOVE) {
            textAction.range = NSMakeRange(textAction.range.location, textAction.text.length);
          }
        }

        if (![self verifyEdit:textAction]) {
          continue;
        }
        
        NSLog(@"text to be applied: %@, type: %@, location: %d, length: %d",
              textAction.text,
              (textAction.editType) ? @"REMOVE" : @"INSERT",
              textAction.range.location,
              textAction.range.length);
      
        [self updateUndoRedoStacks:textAction];
        [self updateCursors:textAction];
      
        int selfUser = [[TextCollabrifyClient sharedClient] getSelfID];
        if (textAction.user == selfUser && !textAction.isUndo) {
          // If this is our action and not the result of an undo, add it to the undo stack.
          NSLog(@"pushing action onto undo stack, loc: %d, len: %d, text:[%@]",
                textAction.range.location,
                textAction.range.length,
                textAction.text);
          
          [self.undoStack pushBack:textAction];
        } else if (textAction.user == selfUser && textAction.isUndo) {
          // This is our action and an undo - add it to the redo stack.
          [self.redoStack pushBack:textAction];
        }
      
        int finalLocation = textAction.range.location;
        if (textAction.editType == INSERT) {
          [self.globalTruthText insertString:textAction.text atIndex:finalLocation];
        } else {
          NSRange deletedCharactersRange = NSMakeRange(finalLocation - length, length);
          [self.globalTruthText deleteCharactersInRange:deletedCharactersRange];
        }
      }
    }
      
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"calling dispatch async");
      [textView setText:[NSString stringWithString:self.globalTruthText]];

      TextCollabrifyClient *textClient = [TextCollabrifyClient sharedClient];
      NSNumber* user = [NSNumber numberWithInt:[textClient getSelfID]];
      NSNumber* selfCursor = [self.userCursors objectForKey:user];
      
      // avoid cyclical cursor movement -> callback -> action loop.
      if ([[UIDevice currentDevice] systemVersion].intValue > 6) {
        NSLog(@"changing cursor, text from input to YES");
        textChangeFromInput = YES;
      }
      cursorChangeFromInput = YES;
      
      textView.selectedRange = NSMakeRange(selfCursor.intValue, 0);
      
      // SEMAPHORE SIGNAL
    });
      
  } @catch (NSException *exception) {
    NSLog(@" *** Exception thrown *** - \n %@", exception.reason);
    [[TextCollabrifyClient sharedClient] deleteSession];
    
    // SEMAPHORE SIGNAL
  }
}

// Loop through the cursors and update the positions based on the text action.
- (void)updateCursors:(TextAction *)textAction {
  int leftIndex = textAction.range.location - textAction.range.length;
  int rightIndex = (textAction.editType == REMOVE) ?
  textAction.range.location : textAction.range.location + textAction.text.length;
  
  for (id key in [self.userCursors allKeys]) {
    NSNumber* location = [self.userCursors objectForKey:key];
    NSLog(@"cursor location is %d, action location: %d, length: %d, text: [%@]",
          location.intValue, textAction.range.location, textAction.range.length, textAction.text);
    if (textAction.editType == REMOVE) {
      if (location.intValue > rightIndex) {
        location = [NSNumber numberWithInt:(location.intValue - textAction.range.length)];
      } else if (location.intValue > leftIndex) {
        location = [NSNumber numberWithInt:leftIndex];
      }
    } else {
      if (location.intValue >= leftIndex) {
        location = [NSNumber numberWithInt:(location.intValue + textAction.text.length)];
        NSLog(@"moving cursor up to %d", location.intValue);
      }
    }
    
    [self.userCursors setObject:location forKey:key];
  }
}

// Update the undo and redo stacks to reflect the current update from the server. This includes altering
// the location of edits in the undo/redo stacks as well as throwing them out if they become invalid.
- (void)updateUndoRedoStacks:(TextAction *)newAction {
  [self updateEditStack:self.undoStack forTextAction:newAction];
  [self updateEditStack:self.redoStack forTextAction:newAction];
}

- (void)updateEditStack:(Deque *)editStack forTextAction:(TextAction *)newAction {
  int leftIndexNew = newAction.range.location - newAction.range.length;
  int rightIndexNew = (newAction.editType == REMOVE) ?
      newAction.range.location : newAction.range.location + newAction.text.length;
  
  int stackSize = [editStack size];
  for (int i = 0; i < stackSize; ++i) {
    TextAction *temp = [editStack popFront];
    int leftIndexUndo = temp.range.location - temp.range.length;
    int rightIndexUndo = (temp.editType == REMOVE) ?
        temp.range.location : temp.range.location + temp.text.length;
    
    if (temp.editType == INSERT) {
      if (newAction.editType == INSERT &&
          (leftIndexNew > leftIndexUndo && leftIndexNew < rightIndexUndo)) {
        // The new action has split up this insertion on the undo stack. Throw it out.
        NSLog(@"Throwing out undo/redo insertion because of insertion");
        continue;
      } else if (newAction.editType == REMOVE &&
                 (leftIndexNew < rightIndexUndo && rightIndexNew > leftIndexUndo)) {
        // The new action has deleted some of this insertion on the undo stack. Throw it out.
        NSLog(@"Throwing out undo/redo insertion because of deletion");
        continue;
      }
    }
    
    // We haven't thrown out the undo action. Update it to reflect the new change.
    if (leftIndexNew < leftIndexUndo) {
      if (newAction.editType == INSERT) {
        temp.range = NSMakeRange(temp.range.location + newAction.text.length, temp.range.length);
      } else {
        temp.range = NSMakeRange(temp.range.location - newAction.range.length, temp.range.length);
      }
    }
    
    [editStack pushBack:temp];
  }
}

// We care about delete's that try to delete crap that isn't there.
- (BOOL)verifyEdit:(TextAction *)action {
  // All inserts are OK.
  if (action.editType == INSERT) {
    return YES;
  }
  
  NSRange rangeToDelete = NSMakeRange(action.range.location - action.range.length,
                                      action.range.length);
  NSLog(@"Verifying delete. Global truth is %@ and range is loc: %d len: %d",
        self.globalTruthText,
        rangeToDelete.location,
        rangeToDelete.length);
  
  if (![[self.globalTruthText substringWithRange:rangeToDelete] isEqualToString:action.text]) {
    return NO;
  }
  return YES;
}

#pragma mark -
#pragma mark Undo and Redo

- (void)undo {
  
  // SEMAPHORE WAIT
  
  if ([self.undoStack empty]) {
    // SEMAPHORE SIGNAL
    return;
  }
  
  TextAction *undoAction;
  TextAction *lastAction = [self.undoStack popBack];
  
  if (lastAction.editType == INSERT) {
    undoAction = [[TextAction alloc] initWithUser:lastAction.user
                                             text:lastAction.text
                                         editType:REMOVE];
    undoAction.range = NSMakeRange(lastAction.range.location + lastAction.text.length,
                                   lastAction.text.length);
  } else {
    undoAction = [[TextAction alloc] initWithUser:lastAction.user
                                             text:lastAction.text
                                         editType:INSERT];
    undoAction.range = NSMakeRange(lastAction.range.location - lastAction.range.length, 0);
  }
  undoAction.isUndo = YES;
  
  NSLog(@"Popped out undo action: loc: %d, len: %d, text: [%@]",
        undoAction.range.location,
        undoAction.range.length,
        undoAction.text);
  
  Deque* actions = [[Deque alloc] init];
  [actions pushBack:undoAction];
  
  [[TextCollabrifyClient sharedClient] sendActions:actions];
}

- (void)redo {
  
  // SEMAPHORE WAIT
  
  if ([self.redoStack empty]) {
    // SEMAPHORE SIGNAL
    return;
  }
  
  //TextAction* redoAction;
  //TextAction* lastAction;
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
    action = [deque popFront];
    NSLog(@"Queue entry: location: %d, length: %d, text: [%@]",
          action.range.location,
          action.range.length,
          action.text);
    [deque pushBack:action];
  }
}

@end
