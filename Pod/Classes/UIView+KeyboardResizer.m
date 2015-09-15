//
//  UIView+KeyboardResizer.m
//
//  Created by Toshiro Sugii on 3/1/15.
//  Copyright (c) 2015 Toshiro Sugii. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+KeyboardResizer.h"

static const int kPropertiesKey;

@interface TXProperties : NSObject

@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) id<UIViewKeyboardResizerDelegate> observer;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

@end

@implementation TXProperties

@end

@interface UIView (KeyboardResizerPrivate)

- (void)keyboardResizerWillShown:(NSNotification *)aNotification;
- (void)keyboardResizerWillHide:(NSNotification *)aNotification;
- (void)moveTextViewForKeyboardResizer:(NSNotification*)aNotification up:(BOOL)up;
- (void)tapGesture:(UIGestureRecognizer *)gesture;

@end

@implementation UIView (KeyboardResizer)

- (TXProperties *)properties
{
  TXProperties *properties = objc_getAssociatedObject(self, &kPropertiesKey);
  if ( !properties ) {
    properties = [[TXProperties alloc] init];
    objc_setAssociatedObject(self, &kPropertiesKey, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    [properties release];
#endif
  }
  return properties;
}

- (void)startKeyboardObserverWithDelegate:(id<UIViewKeyboardResizerDelegate>)delegate
{
  [self startKeyboardResizerObserverWithDelegate:delegate];
}

- (void)startKeyboardObserver
{
  [self startKeyboardResizerObserverWithDelegate:nil];
}

- (void)stopKeyboardObserver
{
  [self stopKeyboardResizerObserver];
}

- (void)startKeyboardResizerObserverWithDelegate:(id<UIViewKeyboardResizerDelegate>)delegate
{
  if ([self properties].started)
    [self stopKeyboardResizerObserver];
  
  [self properties].observer = delegate;
  [self properties].initialFrame = self.frame;
  [self properties].gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
  
  [self addGestureRecognizer:[self properties].gestureRecognizer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardResizerWillShown:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardResizerWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  [self properties].started = YES;
}

- (void)startKeyboardResizerObserver
{
  [self startKeyboardResizerObserverWithDelegate:nil];
}

- (void)stopKeyboardResizerObserver
{
  [self properties].observer = nil;
  [self properties].initialFrame = CGRectZero;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [self removeGestureRecognizer:[self properties].gestureRecognizer];
  [self properties].gestureRecognizer = nil;
  
  [self properties].started = NO;
}

- (void)moveTextViewForKeyboardResizer:(NSNotification*)aNotification up:(BOOL)up
{
  NSDictionary* userInfo = [aNotification userInfo];
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;
  CGRect keyboardEndFrame;
  
  [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
  [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:animationCurve];
  
  if ([self properties].observer && [[self properties].observer respondsToSelector:@selector(viewWillResize:)])
    [[self properties].observer viewWillResize:self];
  
  CGRect newFrame = self.frame;
  newFrame.size.height = [self properties].initialFrame.size.height - (up ? keyboardEndFrame.size.height : 0.f);
  self.frame = newFrame;
  
  if ([self properties].observer && [[self properties].observer respondsToSelector:@selector(viewDidResize:)])
      [[self properties].observer viewDidResize:self];
  
  [UIView commitAnimations];
}

- (void)keyboardResizerWillShown:(NSNotification*)aNotification
{
  [self moveTextViewForKeyboardResizer:aNotification up:YES];
}

- (void)keyboardResizerWillHide:(NSNotification*)aNotification
{
  [self moveTextViewForKeyboardResizer:aNotification up:NO];
}

- (void)tapGesture:(UIGestureRecognizer *)gesture
{
  if ([self properties].observer && [[self properties].observer respondsToSelector:@selector(viewDidTap:)])
    [[self properties].observer viewDidTap:self];
}

@end
