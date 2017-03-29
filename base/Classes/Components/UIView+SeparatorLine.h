//
//  UIView+SeparatorLine.h
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SeparatorLine)

- (void)drawSeparatorLineToPosition:(UIRectEdge)pos lineWidth:(CGFloat)lineWidth;
/// Default width is ONE_PIXEL,  (1.f / [UIScreen mainScreen].scale)
- (void)drawSeparatorLineToPosition:(UIRectEdge)pos;

@end
