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
#import <ReactiveObjC.h>
#import <Masonry.h>
#import <FLAnimatedImageView+WebCache.h>

@interface AZProgressHUD ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, assign) CGFloat delayHidden;
@property (nonatomic, strong) FLAnimatedImageView *gifView;
@property (nonatomic, strong) UIView *defaultContentView;
@end

@implementation AZProgressHUD

+ (void)showAzazieHUD {
    AZProgressHUD.hud.show;
}

+ (instancetype)hud {
    return AZProgressHUD.configureInstance;
}

+ (instancetype)configureInstance {
    AZProgressHUD *hud = [[AZProgressHUD alloc] init];
    hud.animationType = AZProgressHUDAnimationTypeDefault;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    hud.margin = 0;
    hud.delayHidden = DISPATCH_TIME_NOW;
    hud.blocked(YES).autoremoveOnHidden(YES).grace(0.5f).coverredWindow(YES).contentView(hud.defaultContentView);
    return hud;
}

- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow {
    return ^(BOOL isCoverredWindow) {
        return self.maskColor(isCoverredWindow?UIColorMakeWithRGBA(0, 0, 0, 0.8):UIColorClear);
    };
}
- (AZProgressHUD *(^)(BOOL isBlocked))blocked {
    return ^(BOOL isBlocked) {
        self.backgroundView.userInteractionEnabled = isBlocked;
        return self;
    };
}
- (AZProgressHUD * _Nonnull (^)(CGFloat))hideAfterDelay {
    return ^(CGFloat time) {
        self.delayHidden = time;
        return self;
    };
}
- (AZProgressHUD *(^)(BOOL autoremoveOnHidden))autoremoveOnHidden {
    return ^(BOOL autoremoveOnHidden) {
        self.removeFromSuperViewOnHide = autoremoveOnHidden;
        return self;
    };
}
- (AZProgressHUD *(^)(CGFloat graceTime))grace {
    return ^(CGFloat graceTime) {
        self.graceTime = graceTime;
        return self;
    };
}
- (AZProgressHUD *(^)(UIColor *color))maskColor {
    return ^(UIColor *color) {
        self.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.backgroundView.color = color;
        return self;
    };
}
- (AZProgressHUD *(^)(NSString *text))text {
    return ^(NSString *text) {
        if (text) {
            NSCAssert(self.customView == self.defaultContentView, @"the content view must be defaultContentView while setting text");
            self.textLabel.text = text;
            [self.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self.customView);
                make.width.height.mas_equalTo(40);
            }];
        }
        return self;
    };
}
- (AZProgressHUD *(^)(NSString *detailText))detailText {
    return ^(NSString *detailText) {
        if (detailText) {
            NSCAssert(self.customView == self.defaultContentView, @"the content view must be defaultContentView while setting detailText");
            self.detailTextLabel.text = detailText;
            [self.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self.customView);
                make.width.height.mas_equalTo(40);
            }];
        }
        return self;
    };
}
- (AZProgressHUD *(^)(UIView  *view))contentView {
    return ^(UIView *view) {
        self.mode = MBProgressHUDModeCustomView;
        Method method = class_getInstanceMethod(view.class, @selector(intrinsicContentSize));
        BOOL isImplemented = class_addMethod(view.class, @selector(intrinsicContentSize), method_getImplementation(method), method_getTypeEncoding(method));
        NSCAssert(!(isImplemented && view!=self.defaultContentView), @"the custom content view must override selector 'intrinsicContentSize'");
        self.customView = view;
        return self;
    };
}
- (AZProgressHUD *(^)(CGSize size))minContentSize {
    return ^(CGSize size) {
        self.minSize = size;
        return self;
    };
}
- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))animateType {
    return ^(AZProgressHUDAnimationType animationType) {
        self.animationType = animationType;
        return self;
    };
}
- (AZProgressHUD *(^)(UIView *view))inView {
    return ^(UIView *view) {
        if (view) {
            self.frame = view.bounds;
            [view addSubview:self];
            return self;
        } else {
            return self;
        }
    };
}

- (void)show {
    if (!self.superview) {
        self.inView(UIApplication.sharedApplication.keyWindow);
    }
    [self showAnimated:YES];
}

- (void)hide {
    [self hideAnimated:YES afterDelay:self.delayHidden];
}

+ (void)hiddenAnimated:(BOOL)isAnimated {
    [(AZProgressHUD *)[AZProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow] hide];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(18) textColor:UIColorWhite];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel {
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorWhite];
        _detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailTextLabel.numberOfLines = 0;
        [_detailTextLabel setQmui_lineHeight:18];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailTextLabel;
}

- (FLAnimatedImageView *)gifView {
    if (!_gifView) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"refresh_hud" ofType:@"gif"]]];
        _gifView = imageView;
    }
    return _gifView;
}

- (UIView *)defaultContentView {
    if (!_defaultContentView) {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectZero];
        [customView addSubview:self.gifView];
        [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(customView);
            make.width.height.mas_equalTo(40);
        }];
        [customView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gifView.mas_bottom).offset(24);
            make.centerX.equalTo(self.gifView);
        }];
        [customView addSubview:self.detailTextLabel];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_bottom).offset(24);
            make.bottom.left.right.equalTo(customView);
        }];
        _defaultContentView = customView;
    }
    return _defaultContentView;
}

@end
