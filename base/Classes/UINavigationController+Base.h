//
//  UINavigationController+Base.h
//  base
//
//  Created by Demi on 30/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Base)

/// If you hides navigationBar, you cann't interactive pop view controller via interactivePopGestureRecognizer.
/// So we create a delegate proxy and set to interactivePopGestureRecognizer's delegate.
/// Solved!
- (void)makeAlwaysInteractivePopGestureRecognizer;

@end
