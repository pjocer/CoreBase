//
//  UIView+NetworkFailed.h
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NetworkLoading.h"

@interface UIView (NetworkFailed)

- (UIView *)addSubviewForNetworkFailed;
- (UIView *)addSubviewForNetworkFailedWithTapHandler:(NetworkViewTapHandler)handler;

- (UIView *)addSubviewForNetworkFailedWithOffsetY:(CGFloat)offsetY;
- (UIView *)addSubviewForNetworkFailedWithOffsetY:(CGFloat)offsetY tapHandler:(NetworkViewTapHandler)handler;

- (void)removeSubviewForNetworkFailed;

@end
