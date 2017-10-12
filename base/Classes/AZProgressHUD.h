//
//  AZProgressHUD.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

typedef NS_ENUM(NSInteger, AZProgressHUDAnimationType) {
    AZProgressHUDAnimationTypeDefault = MBProgressHUDAnimationFade,
    AZProgressHUDAnimationTypeSpring = MBProgressHUDAnimationZoomOut,
};

@interface AZProgressHUD : MBProgressHUD
NS_ASSUME_NONNULL_BEGIN
- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow;

- (AZProgressHUD *(^)(BOOL isBlocked))blocked;

- (AZProgressHUD *(^)(BOOL autoremoveOnHidden))autoremoveOnHidden;

- (AZProgressHUD *(^)(CGFloat graceTime))grace;

- (AZProgressHUD *(^)(CGFloat delay))hideAfterDelay;

- (AZProgressHUD *(^)(NSString *text))text;

- (AZProgressHUD *(^)(NSString *detailText))detailText;

- (AZProgressHUD *(^)(UIView  *view))inView;

- (AZProgressHUD *(^)(UIView  *view))contentView;

- (AZProgressHUD *(^)(UIColor *color))maskColor;

- (AZProgressHUD *(^)(CGSize size))minContentSize;

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))displayAnimationType;

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))hiddenAnimationType;

// display or hidden the normal Azazia-HUD in App's key window with default configuration.
+ (void)showAzazieHUD;
+ (void)showAzazieHUDWithText:(NSString *)aText detailText:(NSString *)aText;
+ (void)hiddenAnimated:(BOOL)isAnimated;

// create an instance by default configuration.
+ (instancetype)hud;
- (void)show;
- (void)hide;
NS_ASSUME_NONNULL_END
@end
