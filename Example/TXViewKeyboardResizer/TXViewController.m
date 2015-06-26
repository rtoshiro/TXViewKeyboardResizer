//
//  TXViewController.m
//  TXViewKeyboardResizer
//
//  Created by rtoshiro on 06/01/2015.
//  Copyright (c) 2014 rtoshiro. All rights reserved.
//

#import "TXViewController.h"

@interface TXViewController ()

@end

@implementation TXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.scrollView startKeyboardResizerObserverWithDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.scrollView stopKeyboardResizerObserver];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewDidTap:(UIView *)view
{
  for (UIView *subview in self.scrollView.subviews)
  {
    if ([subview isMemberOfClass:[UITextField class]])
      [((UITextField *)subview) resignFirstResponder];
  }
}

@end
