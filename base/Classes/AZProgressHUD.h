//
//  AZProgressHUD.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface AZProgressHUD : MBProgressHUD

+ (instancetype)showAnimatedCoveredWindow;
+ (instancetype)showAnimatedCoveredWindowWithBlocked:(BOOL)isBlocked;

+ (void)hiddenAnimated:(BOOL)isAnimated;

@end
