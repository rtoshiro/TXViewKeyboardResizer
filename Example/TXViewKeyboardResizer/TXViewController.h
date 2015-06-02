//
//  TXViewController.h
//  TXViewKeyboardResizer
//
//  Created by rtoshiro on 06/01/2015.
//  Copyright (c) 2014 rtoshiro. All rights reserved.
//

@import UIKit;
@import TXViewKeyboardResizer;

@interface TXViewController : UIViewController <UIViewKeyboardResizerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
