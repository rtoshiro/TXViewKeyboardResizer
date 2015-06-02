//
//  UIView+KeyboardResizer.m
//  Organiza
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

- (void)keyboardWillShown:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;
- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;
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
  if ([self properties].started)
    [self stopKeyboardObserver];

  [self properties].observer = delegate;
  [self properties].initialFrame = self.frame;
  [self properties].gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
  
  [self addGestureRecognizer:[self properties].gestureRecognizer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  [self properties].started = YES;
}

- (void)startKeyboardObserver
{
  [self startKeyboardObserverWithDelegate:nil];
}

- (void)stopKeyboardObserver
{
  [self properties].observer = nil;
  [self properties].initialFrame = CGRectZero;

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [self removeGestureRecognizer:[self properties].gestureRecognizer];
  [self properties].gestureRecognizer = nil;
  
  [self properties].started = NO;
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
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

- (void)keyboardWillShown:(NSNotification*)aNotification
{
  [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
  [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void)tapGesture:(UIGestureRecognizer *)gesture
{
  if ([self properties].observer && [[self properties].observer respondsToSelector:@selector(viewDidTap:)])
    [[self properties].observer viewDidTap:self];
}

@end
