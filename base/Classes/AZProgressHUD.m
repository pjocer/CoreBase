//
//  AZProgressHUD.m
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "AZProgressHUD.h"
#import <UIImage+TXGIF.h>
#import <QMUIKit.h>

@interface AZProgressHUD ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AZProgressHUD

+ (instancetype)showAnimatedCoveredWindow {
    return [self showAnimatedCoveredWindowWithBlocked:YES];
}

+ (instancetype)showAnimatedCoveredWindowWithBlocked:(BOOL)isBlocked {
    AZProgressHUD *hud = [AZProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = UIColorMakeWithRGBA(0, 0, 0, 0.3);
    hud.backgroundView.userInteractionEnabled = isBlocked;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 0;
    UIImage *animateImage = [UIImage tx_gifAnimatedImageWithFile:[[NSBundle mainBundle] pathForResource:@"refresh_hud" ofType:@"gif"]];
    hud.customView = [[UIImageView alloc] initWithImage:animateImage];
    return hud;
}

+ (void)hiddenAnimated:(BOOL)isAnimated {
    [AZProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

@end
