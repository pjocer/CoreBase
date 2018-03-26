//
//  AZProgressHUD.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <QMUIKit/QMUIKit.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>

typedef NS_ENUM(NSInteger, AZProgressHUDAnimationType) {
    AZProgressHUDAnimationTypeDefault = MBProgressHUDAnimationFade,
    AZProgressHUDAnimationTypeSpringOut = MBProgressHUDAnimationZoomOut,
    AZProgressHUDAnimationTypeSpringIn = MBProgressHUDAnimationZoomIn,
};

@interface AZProgressHUD : MBProgressHUD
NS_ASSUME_NONNULL_BEGIN
- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow;

- (AZProgressHUD *(^)(BOOL isBlocked))blocked;

- (AZProgressHUD *(^)(BOOL autoremoveOnHidden))autoremoveOnHidden;

- (AZProgressHUD *(^)(CGFloat graceTime))grace;

- (AZProgressHUD *(^)(CGFloat delay))hideAfterDelay;

- (AZProgressHUD *(^)(CGFloat delay))distanceFromKeyboard;

- (AZProgressHUD *(^)(NSString *text))text;

- (AZProgressHUD *(^)(NSString *detailText))detailText;

- (AZProgressHUD *(^)(UIView  *view))inView;

- (AZProgressHUD *(^)(UIView  *view))contentView;

- (AZProgressHUD *(^)(UIColor *color))maskColor;

- (AZProgressHUD *(^)(CGSize size))minContentSize;

- (AZProgressHUD *(^)(CGSize size))maxContentSize;

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))displayAnimationType;

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))hiddenAnimationType;

// create an instance by default configuration.
+ (instancetype)hud;
- (void)show;
- (void)hide;
NS_ASSUME_NONNULL_END
@end

@interface AZProgressHUD (AzazieDefault)
// display or hidden the normal Azazia-HUD in App's key window with default configuration.
+ (instancetype)showAzazieHUD;
+ (instancetype)showAzazieHUDWithText:(NSString *)aText detailText:(NSString *)aText;
+ (instancetype)showAzazieHUDWithText:(NSString *)aText detailText:(NSString *)aText inView:(UIView *)aView;

+ (void)hiddenAnimated:(BOOL)isAnimated;
+ (void)hiddenAnimated:(BOOL)isAnimated inView:(UIView *)view;
@end

@interface AZProgressHUDDefaultContentView : UIView
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *detailTextLabel;
@property (nonatomic, strong, readonly) FLAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *actionLabel;
@end
