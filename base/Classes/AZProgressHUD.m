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
@end

@implementation AZProgressHUD

+ (void)showAzazieHUD {
    AZProgressHUD.hud.inView(UIApplication.sharedApplication.keyWindow).show;
}

+ (instancetype)hud {
    return AZProgressHUD.configureInstance;
}

+ (instancetype)configureInstance {
    AZProgressHUD *hud = [[AZProgressHUD alloc] init];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    hud.margin = 0;
    hud.delayHidden = DISPATCH_TIME_NOW;
    hud.blocked(YES).autoremoveOnHidden(YES).grace(0.5f).coverredWindow(YES);
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
            self.textLabel.text = text;
            [self.gifView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self.customView);
            }];
        }
        return self;
    };
}
- (AZProgressHUD *(^)(NSString *detailText))detailText {
    return ^(NSString *detailText) {
        if (detailText) {
            self.detailTextLabel.text = detailText;
            [self.gifView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self.customView);
            }];
        }
        return self;
    };
}

- (AZProgressHUD *(^)(UIView *view))inView {
    return ^(UIView *view) {
        if (view) {
            self.frame = view.bounds;
            [view addSubview:self];
            UIView *customView = [[UIView alloc] initWithFrame:CGRectZero];
            @weakify(customView);
            [[[customView rac_signalForSelector:@selector(didMoveToSuperview)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(customView)
                [customView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(SCREEN_WIDTH*2/3.f);
                }];
                [customView addSubview:self.gifView];
                [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(customView);
                    make.width.height.mas_equalTo(40);
                }];
                [customView addSubview:self.textLabel];
                [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.gifView.mas_bottom).offset(24);
                    make.centerX.equalTo(self.gifView);
                }];
                [customView addSubview:self.detailTextLabel];
                [self.detailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.textLabel.mas_bottom).offset(24);
                    make.bottom.left.right.equalTo(customView);
                }];
            }];
            self.customView = customView;
            return self;
        } else {
            return self;
        }
    };
}

- (void)show {
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

@end
