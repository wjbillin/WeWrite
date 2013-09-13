//
//  TextViewDelegate.m
//  WeWrite
//
//  Created by William Joshua Billingham on 9/12/13.
//  Copyright (c) 2013 William Joshua Billingham. All rights reserved.
//

#import "Deque.h"
#import "TextViewDelegate.h"

@interface TextAction : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *autocorrectText;

@end

@implementation TextAction

- (id)init:(NSRange)range text:(NSString *)text autocorrectText:(NSString *)autoText {
  if (self = [super init]) {
    _range = range;
    _text = text;
    _autocorrectText = autoText;
  }
  return self;
}

@end

@interface TextViewDelegate ()

@end

@implementation TextViewDelegate

- (id)init:(UITextView *)textView {
  if (self = [super init]) {
    _count = 0;
    _redoStack = [[Deque alloc] init];
    _undoStack = [[Deque alloc] init];
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
  
  if (range.location == 0 && range.length == 0 && text.length == 0) {
    // User is backspacing at the beginning of the document. Don't bother recording anything.
    return YES;
  }
  
  NSString *autoText = nil;
  if (range.length > 0 && text.length == 0) {
    // This action is a delete. Find out what characters were deleted.
    text = [textView.text substringWithRange:range];
    NSLog(@"Deleted string is [%@]", text);
  } else if (range.length > 0 && text.length > 0) {
    // This action is an autocomplete/correct. Store deleted text and autocompleted text.
    autoText = text;
    text = [textView.text substringWithRange:range];
  }
  
  [self.undoStack push:[[TextAction alloc] init:range text:text autocorrectText:autoText]];

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  NSLog(@"TextViewDidChange callback, selected position: %d", textView.selectedRange.location);
  
  TextAction *lastAction = [self.undoStack frontStack];
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

- (void)undo:(UITextView *)textView {
  TextAction *lastAction = [self.undoStack popStack];
  
  if (lastAction) {
    NSLog(@"Undoing last action, location: %d, length: %d, text: [%@]",
          lastAction.range.location,
          lastAction.range.length,
          lastAction.text);
    if (lastAction.range.length > 0 && !lastAction.autocorrectText) {
      [self undoRemove:lastAction text:textView.text];
    } else if (lastAction.range.length > 0 && lastAction.autocorrectText) {
      [self undoAutocorrect:lastAction text:textView.text];
    } else {
      [self undoAdd:lastAction text:textView.text];
    }
    [self.redoStack push:lastAction];
  }
}

- (void)undoAdd:(TextAction *)addAction text:(NSString *)text {
  text = [NSString stringWithFormat:@"%@%@",
          [text substringToIndex:addAction.range.location],
          [text substringFromIndex:(addAction.range.location + addAction.text.length)]];
}

- (void)undoAutocorrect:(TextAction *)autocorrectAction text:(NSString *)text {
  text = [NSString stringWithFormat:@"%@%@%@",
          [text substringToIndex:autocorrectAction.range.location],
          autocorrectAction.text,
          [text substringFromIndex:(autocorrectAction.range.location +
                                    autocorrectAction.autocorrectText.length)]];
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
