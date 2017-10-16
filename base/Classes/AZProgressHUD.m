//
//  AZProgressHUD.m
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "AZProgressHUD.h"
#import <QMUIKit.h>
#import <ReactiveObjC.h>
#import <Masonry.h>
#import <FLAnimatedImageView+WebCache.h>

@interface AZProgressHUDDefaultContentView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) FLAnimatedImageView *gifView;
@end

@implementation AZProgressHUDDefaultContentView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.gifView];
        [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(40);
        }];
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gifView.mas_bottom).offset(24);
            make.centerX.equalTo(self.gifView);
        }];
        [self addSubview:self.detailTextLabel];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_bottom).offset(24);
            make.bottom.left.right.equalTo(self);
        }];
    }
    return self;
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

@interface AZProgressHUD ()
@property (nonatomic, assign) CGFloat _hideAfterDelay;
@property (nonatomic, assign) CGSize _minContentSize;
@property (nonatomic, assign) CGSize _maxContentSize;
@property (nonatomic, assign) AZProgressHUDAnimationType _displayAnimationType;
@property (nonatomic, assign) AZProgressHUDAnimationType _hiddenAnimationType;
@property (nonatomic, strong) AZProgressHUDDefaultContentView *defaultContentView;
@end

@implementation AZProgressHUD

+ (void)showAzazieHUD {
    [self showAzazieHUDWithText:nil detailText:nil];
}

+ (void)showAzazieHUDWithText:(NSString *)text detailText:(NSString *)detail {
    AZProgressHUD *hud = AZProgressHUD.hud.text(text).detailText(detail);
    [hud show];
}

+ (instancetype)hud {
    return AZProgressHUD.configureInstance;
}

+ (instancetype)configureInstance {
    AZProgressHUD *hud = [[AZProgressHUD alloc] init];
    hud.displayAnimationType(AZProgressHUDAnimationTypeSpringOut).hiddenAnimationType(AZProgressHUDAnimationTypeDefault);
    hud.blocked(YES).autoremoveOnHidden(YES).hideAfterDelay(DISPATCH_TIME_NOW);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    return hud;
}

- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow {
    return ^(BOOL isCoverredWindow) {
        return self.inView(UIApplication.sharedApplication.keyWindow).maskColor(isCoverredWindow?UIColorMakeWithRGBA(0, 0, 0, 0.8):UIColorClear);
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
        self._hideAfterDelay = time;
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
            NSCAssert(self.customView == self.defaultContentView, @"Do not use the 'text' attribute after custom content view set up");
            self.defaultContentView.textLabel.text = text;
            [self.defaultContentView.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
            NSCAssert(self.customView == self.defaultContentView, @"Do not use the 'detailText' attribute after custom content view set up");
            self.defaultContentView.detailTextLabel.text = detailText;
            [self.defaultContentView.gifView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        self.customView = view;
        return self;
    };
}
- (AZProgressHUD *(^)(CGSize size))minContentSize {
    return ^(CGSize size) {
        self._minContentSize = size;
        [self handleConstraintsFor:self.customView size:size isMax:NO];
        return self;
    };
}
- (AZProgressHUD *(^)(CGSize size))maxContentSize {
    return ^(CGSize size) {
        self._maxContentSize = size;
        [self handleConstraintsFor:self.customView size:size isMax:YES];
        return self;
    };
}
- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))displayAnimationType {
    return ^(AZProgressHUDAnimationType animationType) {
        self._displayAnimationType = animationType;
        return self;
    };
}

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))hiddenAnimationType {
    return ^(AZProgressHUDAnimationType animationType) {
        self._hiddenAnimationType = animationType;
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
        self.coverredWindow(YES);
    }
    if (!self.customView) {
         self.contentView(self.defaultContentView).minContentSize(CGSizeMake(40, 40)).maxContentSize(CGSizeMake(295, SCREEN_HEIGHT));
    }
    NSCAssert(self.canShow, @"set 'minContentSize' or 'maxContentSize' with custom content view before displaying");
    self.animationType = self._displayAnimationType;
    [self showAnimated:YES];
}

- (void)hide {
    self.animationType = self._hiddenAnimationType;
    [self hideAnimated:YES afterDelay:self._hideAfterDelay];
}

+ (void)hiddenAnimated:(BOOL)isAnimated {
    [self hiddenAnimated:isAnimated inView:UIApplication.sharedApplication.keyWindow];
}
+ (void)hiddenAnimated:(BOOL)isAnimated inView:(nonnull UIView *)view {
    [(AZProgressHUD *)[AZProgressHUD HUDForView:view] hide];
}
- (void)handleConstraintsFor:(UIView *)view size:(CGSize)size isMax:(BOOL)isMax {
    if (self.canShow) {
        void(^block)(MASConstraintMaker *) = ^(MASConstraintMaker *make) {
            if (isMax) {
                make.size.mas_lessThanOrEqualTo(size);
            } else {
                make.size.mas_greaterThanOrEqualTo(size);
            }
        };
        if (view.superview) {
            [view mas_updateConstraints:block];
        } else {
            @weakify(view);
            [[[view rac_signalForSelector:@selector(didMoveToSuperview)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(view);
                [view mas_updateConstraints:block];
            }];
        }
    }
}

- (BOOL)canShow {
    return !(CGSizeEqualToSize(CGSizeZero, self._minContentSize)&&CGSizeEqualToSize(CGSizeZero, self._maxContentSize));
}

- (AZProgressHUDDefaultContentView *)defaultContentView {
    if (!_defaultContentView) {
        _defaultContentView = [[AZProgressHUDDefaultContentView alloc] init];
    }
    return _defaultContentView;
}

@end
