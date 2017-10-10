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

@interface AZProgressHUD ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, weak) UIView *parentView;
@end

@implementation AZProgressHUD

+ (instancetype)showAzazieHUD {
    return [[self configurInstanceInView:[UIApplication sharedApplication].keyWindow] coverredWindow](YES);
}

+ (instancetype)configurInstanceInView:(UIView *)view {
    AZProgressHUD *hud = [AZProgressHUD showHUDAddedTo:view animated:YES];
    hud.parentView = view;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    hud.margin = 0;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectZero];
    @weakify(customView);
    [[[customView rac_signalForSelector:@selector(didMoveToSuperview)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(customView)
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH*2/3.f);
        }];
        [customView addSubview:hud.gifView];
        [hud.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(customView);
        }];
        [customView addSubview:hud.textLabel];
        [hud.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hud.gifView.mas_bottom).offset(24);
            make.centerX.equalTo(hud.gifView);
        }];
        [customView addSubview:hud.detailTextLabel];
        [hud.detailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hud.textLabel.mas_bottom).offset(24);
            make.bottom.left.right.equalTo(customView);
        }];
    }];
    hud.customView = customView;
    hud.blocked(YES).autoremoveOnHidden(YES).grace(0.5f);
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
            [self.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
            [self.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self.customView);
            }];
        }
        return self;
    };
}

- (AZProgressHUD *(^)(UIView *view))inView {
    return ^(UIView *view) {
        if (view) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideAnimated:NO];
            });
            return [[AZProgressHUD configurInstanceInView:view] maskColor](UIColorMakeWithRGBA(255, 255, 255, 0.8));
        } else {
            return self;
        }
    };
}

+ (void)hiddenAnimated:(BOOL)isAnimated {
    [AZProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:isAnimated];
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

- (UIImageView *)gifView {
    if (!_gifView) {
        UIImage *animateImage = [UIImage tx_gifAnimatedImageWithFile:[[NSBundle mainBundle] pathForResource:@"refresh_hud" ofType:@"gif"]];
        _gifView = [[UIImageView alloc] initWithImage:animateImage];
    }
    return _gifView;
}

@end
