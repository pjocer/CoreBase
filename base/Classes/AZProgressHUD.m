//
//  AZProgressHUD.m
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "AZProgressHUD.h"
#import <ReactiveObjC.h>
#import <Masonry.h>
#import <TXFire.h>

#define IMAGE_HEADER_SQUARE_SIZE 120/ScreenScale
#define REFRESH_GIF_IMAGE [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"refresh_hud" ofType:@"gif"]]]

@interface AZProgressHUDDefaultContentView ()
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@property (nonatomic, strong, readwrite) UILabel *detailTextLabel;
@property (nonatomic, strong, readwrite) FLAnimatedImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *actionLabel;
@property (nonatomic, strong, readwrite) MASConstraint *showActionLabel;
@end

@implementation AZProgressHUDDefaultContentView

- (instancetype)init {
    if (self = [super init]) {
        return self.commitSubviews.makeConstraints.subscribe;
    }
    return self;
}

- (instancetype)commitSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [self addSubview:self.actionLabel];
    return self;
}

- (instancetype)makeConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(IMAGE_HEADER_SQUARE_SIZE);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(25);
        make.left.right.equalTo(self);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(25);
        make.left.right.equalTo(self);
    }];
    
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextLabel.mas_bottom).offset(18);
        make.centerX.equalTo(self);
        self.showActionLabel = make.size.mas_greaterThanOrEqualTo(CGSizeMake(215, 44)).priorityHigh();
        make.bottom.equalTo(self);
    }];
    [self.showActionLabel deactivate];
    return self;
}

- (instancetype)subscribe {
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(18) textColor:UIColorWhite];
        _textLabel.tx_textAlignment(NSTextAlignmentCenter);
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

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(15) textColor:UIColorMakeWithHex(@"#ffffff")];
        _actionLabel.layer.cornerRadius = 3;
        _actionLabel.layer.masksToBounds = YES;
        _actionLabel.tx_textAlignment(NSTextAlignmentCenter).tx_backgroundColorHex(0xE8437B);
    }
    return _actionLabel;
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

+ (instancetype)showAzazieHUD {
   return [self showAzazieHUDWithText:nil detailText:nil];
}

+ (instancetype)showAzazieHUDWithText:(NSString *)text detailText:(NSString *)detail {
    return [self showAzazieHUDWithText:text detailText:detail inView:nil];
}

+ (instancetype)showAzazieHUDWithText:(NSString *)text detailText:(NSString *)detail inView:(UIView *)aView {
    AZProgressHUD *hud = AZProgressHUD.hud;
    hud.contentView(hud.defaultContentView);
    hud.text(text).detailText(detail);
    [hud show];
    hud.inView(aView);
    return hud;
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
- (AZProgressHUDDefaultContentView *)defaultContentView {
    if (!_defaultContentView) {
        _defaultContentView = [[AZProgressHUDDefaultContentView alloc] init];
        _defaultContentView.imageView.animatedImage = REFRESH_GIF_IMAGE;
    }
    return _defaultContentView;
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
            NSCAssert(self.canUseProperties, @"Do not use 'text' attribute after custom content view set up");
            self.defaultContentView.textLabel.text = text;
            [self updateDefaultContentViewImageHeaderConstraints];
        }
        return self;
    };
}
- (AZProgressHUD *(^)(NSString *detailText))detailText {
    return ^(NSString *detailText) {
        if (detailText) {
            NSCAssert(self.canUseProperties, @"Do not use 'detailText' attribute after custom content view set up");
            self.defaultContentView.detailTextLabel.text = detailText;
            [self updateDefaultContentViewImageHeaderConstraints];
        }
        return self;
    };
}

- (AZProgressHUD *(^)(UIView  *view))contentView {
    return ^(UIView *view) {
        self.mode = MBProgressHUDModeCustomView;
        self.customView = view;
        if ([view isKindOfClass:AZProgressHUDDefaultContentView.class]) {
            self.minContentSize(CGSizeMake(IMAGE_HEADER_SQUARE_SIZE, IMAGE_HEADER_SQUARE_SIZE)).maxContentSize(CGSizeMake(295, SCREEN_HEIGHT));
            AZProgressHUDDefaultContentView *view =self.customView;
            if (view.textLabel.text.length>0||view.detailTextLabel.text.length>0||view.actionLabel.text.length>0) {
                [self updateDefaultContentViewImageHeaderConstraints];
            }
            if (view.actionLabel.text.length>0) {
                [view.showActionLabel activate];
            }
        }
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
         self.contentView(self.defaultContentView);
    }
    NSCAssert(self.canShow, @"set 'minContentSize' or 'maxContentSize' with custom content view before displaying");
    self.animationType = self._displayAnimationType;
    [self subscribeKeyboardIfNeeded];
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

#pragma mark - private methods

- (void)updateDefaultContentViewImageHeaderConstraints {
    AZProgressHUDDefaultContentView *contentView = self.customView;
    [contentView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(contentView);
        make.width.height.mas_equalTo(IMAGE_HEADER_SQUARE_SIZE);
    }];
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
- (void)subscribeKeyboardIfNeeded {
    __block BOOL needSubscribe = NO;
    [self.customView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj canBecomeFirstResponder]) {
            *stop = YES;
            needSubscribe = YES;
        }
    }];
    if (needSubscribe) {
        @weakify(self);
        [[RACObserve(self, customView) combineLatestWith:[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillChangeFrameNotification    object:nil]] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            RACTupleUnpack(UIView *view, NSNotification *notification) = x;
            NSDictionary *info = notification.userInfo;
            NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]|UIViewAnimationOptionCurveEaseOut;
            CGFloat keyboardMinY = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                [self.bezelView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_lessThanOrEqualTo(-(SCREEN_HEIGHT-keyboardMinY+20));
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
        [self.backgroundView.tx_tapGestureRecognizer.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self endEditing:YES];
        }];
    }
}
- (BOOL)canShow {
    return !(CGSizeEqualToSize(CGSizeZero, self._minContentSize)&&CGSizeEqualToSize(CGSizeZero, self._maxContentSize));
}
- (BOOL)canUseProperties {
    return self.customView == self.defaultContentView || [self.customView isKindOfClass:AZProgressHUDDefaultContentView.class];
}


@end
