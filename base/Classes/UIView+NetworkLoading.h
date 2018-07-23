//
//  UIView+NetworkLoading.h
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetworkViewTapHandler)(UIView *networkView);

@interface UIView (NetworkLoading)

- (UIView *)addSubviewForNetworkLoading;
- (UIView *)addSubviewForNetworkLoadingWithTapHandler:(NetworkViewTapHandler)handler;
- (UIView *)addSubviewForNetworkLoadingWithTitle:(NSString *)title detailTexts:(NSArray *)texts;
- (UIView *)addSubviewForNetworkLoadingWithOffsetY:(CGFloat)offsetY;
- (UIView *)addSubviewForNetworkLoadingWithOffsetY:(CGFloat)offsetY tapHandler:(NetworkViewTapHandler)handler;

- (void)removeSubviewForNetworkLoading;

@end
