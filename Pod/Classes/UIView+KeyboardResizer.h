//
//  UIView+KeyboardResizer.h
//
//  Created by Toshiro Sugii on 3/1/15.
//  Copyright (c) 2015 Toshiro Sugii. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewKeyboardResizerDelegate <NSObject>

@optional
- (void)viewWillResize:(UIView *)view;
- (void)viewDidResize:(UIView *)view;
- (void)viewDidTap:(UIView *)view;

@end

@interface UIView (KeyboardResizer)

/**
 *  Make UIView observing keyboard notifications
 */

- (void)startKeyboardObserver __attribute__((deprecated));
- (void)startKeyboardObserverWithDelegate:(id<UIViewKeyboardResizerDelegate>)delegate __attribute__((deprecated));

- (void)startKeyboardResizerObserver;
- (void)startKeyboardResizerObserverWithDelegate:(id<UIViewKeyboardResizerDelegate>)delegate;

/**
 *  Stop observing keyboard notifications
 *  You should call this method before the UIView is released
 */
- (void)stopKeyboardObserver __attribute__((deprecated));

- (void)stopKeyboardResizerObserver;

@end
