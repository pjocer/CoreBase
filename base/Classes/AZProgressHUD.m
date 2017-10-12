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
        @weakify(self);
        [[[self rac_signalForSelector:@selector(didMoveToSuperview)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(@295).priorityHigh;
            }];
        }];
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
@property (nonatomic, assign) CGFloat delayHidden;
@property (nonatomic, assign) AZProgressHUDAnimationType displayType;
@property (nonatomic, assign) AZProgressHUDAnimationType hiddenType;
@property (nonatomic, strong) AZProgressHUDDefaultContentView *defaultContentView;
@end

@implementation AZProgressHUD

+ (void)showAzazieHUD {
    [self showAzazieHUDWithText:nil detailText:nil];
}

+ (void)showAzazieHUDWithText:(NSString *)text detailText:(NSString *)detail {
    AZProgressHUD *hud = AZProgressHUD.hud;
    hud.coverredWindow(YES).contentView(hud.defaultContentView);
    hud.animationType = hud.displayType;
    [hud show];
}

+ (instancetype)hud {
    return AZProgressHUD.configureInstance;
}

+ (instancetype)configureInstance {
    AZProgressHUD *hud = [[AZProgressHUD alloc] init];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorClear;
    hud.delayHidden = DISPATCH_TIME_NOW;
    hud.displayAnimationType(AZProgressHUDAnimationTypeSpring).hiddenAnimationType(AZProgressHUDAnimationTypeDefault).blocked(YES).autoremoveOnHidden(YES);
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
            NSCAssert(self.customView == self.defaultContentView, @"the content view must be defaultContentView while setting detailText");
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
        [self handleConstraintsFor:view];
        return self;
    };
}
- (AZProgressHUD *(^)(CGSize size))minContentSize {
    return ^(CGSize size) {
        self.minSize = size;
        [self handleConstraintsFor:self.customView];
        return self;
    };
}
- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))displayAnimationType {
    return ^(AZProgressHUDAnimationType animationType) {
        self.displayType = animationType;
        return self;
    };
}

- (AZProgressHUD *(^)(AZProgressHUDAnimationType animationType))hiddenAnimationType {
    return ^(AZProgressHUDAnimationType animationType) {
        self.hiddenType = animationType;
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
    NSCAssert(!(self.customView!=self.defaultContentView&&CGSizeEqualToSize(CGSizeZero, self.minSize)), @"set 'minContentSize' with custom content view before showing");
    self.animationType = self.displayType;
    [self showAnimated:YES];
}

- (void)hide {
    self.animationType = self.hiddenType;
    [self hideAnimated:YES afterDelay:self.delayHidden];
}

+ (void)hiddenAnimated:(BOOL)isAnimated {
    [(AZProgressHUD *)[AZProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow] hide];
}

- (void)handleConstraintsFor:(UIView *)view {
    if (view!=self.defaultContentView && !CGSizeEqualToSize(self.minSize, CGSizeZero)) {
        if (view.superview) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.greaterThanOrEqualTo(@(self.minSize.width)).priorityHigh;
                make.height.greaterThanOrEqualTo(@(self.minSize.height)).priorityHigh;
            }];
        } else {
            @weakify(view);
            [[[view rac_signalForSelector:@selector(didMoveToSuperview)] take:1] subscribeNext:^(RACTuple * _Nullable x) {
                @strongify(view);
                [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.greaterThanOrEqualTo(@(self.minSize.width)).priorityHigh;
                    make.height.greaterThanOrEqualTo(@(self.minSize.height)).priorityHigh;
                }];
            }];
        }
    }
}

- (AZProgressHUDDefaultContentView *)defaultContentView {
    if (!_defaultContentView) {
        _defaultContentView = [[AZProgressHUDDefaultContentView alloc] init];
    }
    return _defaultContentView;
}

@end
