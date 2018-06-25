//
//  CountDownView.m
//  mobile
//
//  Created by Jocer on 2018/6/15.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import "CountDownView.h"
#import <Masonry/Masonry.h>

@interface CountDownView ()

@property (nonatomic, strong) UIButton *hourView1;
@property (nonatomic, strong) UIButton *hourView2;

@property (nonatomic, strong) UIButton *minuteView1;
@property (nonatomic, strong) UIButton *minuteView2;

@property (nonatomic, strong) UIButton *secondView1;
@property (nonatomic, strong) UIButton *secondView2;

@property (nonatomic, strong) UILabel *colon1;
@property (nonatomic, strong) UILabel *colon2;

@property (nonatomic) NSTimer *timer;

@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;

@property (nonatomic, assign) BOOL didRegisterNotificaton;

@property (nonatomic, assign) NSTimeInterval endBackgroundTimeInterval;

@property (nonatomic, assign) NSTimeInterval countDownLeftTimeInterval;

@end
@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeValues];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (void)initializeValues {
    _themeColor = [UIColor clearColor];
    _colonColor = [UIColor darkTextColor];
    _textColor = [UIColor darkTextColor];
    _textFont = [UIFont systemFontOfSize:14.0];
    _recoderTimeIntervalDidInBackground = NO;
    _didRegisterNotificaton = NO;
    self.commitSubViews.makeConstraints.backgroundColor = [UIColor clearColor];
}

- (instancetype)commitSubViews {
    [self addSubview:self.hourView1];
    [self addSubview:self.hourView2];
    [self addSubview:self.minuteView1];
    [self addSubview:self.minuteView2];
    [self addSubview:self.secondView1];
    [self addSubview:self.secondView2];
    [self addSubview:self.colon1];
    [self addSubview:self.colon2];
    return self;
}

- (instancetype)makeConstraints {
    [self.hourView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    [self.hourView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourView1.mas_right).offset(1);
        make.top.bottom.equalTo(self.hourView1);
    }];
    [self.colon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourView2.mas_right).offset(3);
        make.centerY.equalTo(self);
    }];
    [self.minuteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colon1.mas_right).offset(3);
        make.top.bottom.equalTo(self);
    }];
    [self.minuteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteView1.mas_right).offset(1);
        make.top.bottom.equalTo(self);
    }];
    [self.colon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteView2.mas_right).offset(3);
        make.centerY.equalTo(self);
    }];
    [self.secondView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.colon2.mas_right).offset(3);
        make.top.bottom.equalTo(self);
    }];
    [self.secondView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondView1.mas_right).offset(1);
        make.top.bottom.right.equalTo(self);
    }];
    return self;
}

- (void)setRecoderTimeIntervalDidInBackground:(BOOL)recoderTimeIntervalDidInBackground {
    _recoderTimeIntervalDidInBackground = recoderTimeIntervalDidInBackground;
    if (recoderTimeIntervalDidInBackground) {
        [self observeNotification];
    }
    
    if (!recoderTimeIntervalDidInBackground && _didRegisterNotificaton) {
        [self removeObservers];
    }
}

#pragma mark init subviews
- (UIButton *)generateNormalButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = _themeColor;
    [button setTitleColor:_textColor forState:UIControlStateNormal];
    button.titleLabel.font = _textFont;
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    [button setTitle:@"0" forState:UIControlStateNormal];
    return button;
}
- (UIButton *)hourView1 {
    if (!_hourView1) {
        _hourView1 = [self generateNormalButton];
    }
    return _hourView1;
}
- (UIButton *)hourView2 {
    if (!_hourView2) {
        _hourView2 = [self generateNormalButton];
    }
    return _hourView2;
}
- (UIButton *)minuteView1 {
    if (!_minuteView1) {
        _minuteView1 = [self generateNormalButton];
    }
    return _minuteView1;
}
- (UIButton *)minuteView2 {
    if (!_minuteView2) {
        _minuteView2 = [self generateNormalButton];
    }
    return _minuteView2;
}
- (UIButton *)secondView1 {
    if (!_secondView1) {
        _secondView1 = [self generateNormalButton];
    }
    return _secondView1;
}
- (UIButton *)secondView2 {
    if (!_secondView2) {
        _secondView2 = [self generateNormalButton];
    }
    return _secondView2;
}
- (UILabel *)colon1 {
    if (!_colon1) {
        _colon1 = [[UILabel alloc] init];
        _colon1.text = @":";
        _colon1.backgroundColor = [UIColor clearColor];
        _colon1.textColor = _colonColor;
        _colon1.font = _textFont;
        _colon1.textAlignment = NSTextAlignmentCenter;
    }
    return _colon1;
}
- (UILabel *)colon2 {
    if (!_colon2) {
        _colon2 = [[UILabel alloc] init];
        _colon2.text = @":";
        _colon2.backgroundColor = [UIColor clearColor];
        _colon2.textColor = _colonColor;
        _colon2.font = _textFont;
        _colon2.textAlignment = NSTextAlignmentCenter;
    }
    return _colon2;
}
#pragma mark set property value
- (void)setThemeColor:(UIColor *)themeColor {
    if (_themeColor != themeColor) {
        _themeColor = themeColor;
        _minuteView1.backgroundColor = themeColor;
        _secondView1.backgroundColor = themeColor;
        _hourView1.backgroundColor = themeColor;
        _minuteView2.backgroundColor = themeColor;
        _secondView2.backgroundColor = themeColor;
        _hourView2.backgroundColor = themeColor;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [_minuteView1 setTitleColor:textColor forState:UIControlStateNormal];
        [_secondView1 setTitleColor:textColor forState:UIControlStateNormal];
        [_hourView1 setTitleColor:textColor forState:UIControlStateNormal];
        [_minuteView2 setTitleColor:textColor forState:UIControlStateNormal];
        [_secondView2 setTitleColor:textColor forState:UIControlStateNormal];
        [_hourView2 setTitleColor:textColor forState:UIControlStateNormal];
    }
}
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        [_minuteView1 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [_secondView1 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [_hourView1 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [_minuteView2 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [_secondView2 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [_hourView2 setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
    }
}
- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        _secondView1.titleLabel.font = textFont;
        _minuteView1.titleLabel.font = textFont;
        _hourView1.titleLabel.font = textFont;
        _secondView2.titleLabel.font = textFont;
        _minuteView2.titleLabel.font = textFont;
        _hourView2.titleLabel.font = textFont;
    }
}

- (void)setColonColor:(UIColor *)colonColor {
    if (_colonColor != colonColor) {
        _colonColor = colonColor;
        _colon1.textColor = _colonColor;
        _colon2.textColor = _colonColor;
    }
}

- (void)setCountDownTimeInterval:(NSTimeInterval)countDownTimeInterval {
    _countDownTimeInterval = countDownTimeInterval;
    if (_countDownTimeInterval < 0) {
        _countDownTimeInterval = 0;
    }
    _second = (int)_countDownTimeInterval % 60;
    _minute = ((int)_countDownTimeInterval / 60) % 60;
    _hour = _countDownTimeInterval / 3600;
    [_hourView1 setTitle:[NSString stringWithFormat:@"%d", _hour/10] forState:UIControlStateNormal];
    [_minuteView1 setTitle:[NSString stringWithFormat:@"%d", _minute/10] forState:UIControlStateNormal];
    [_secondView1 setTitle:[NSString stringWithFormat:@"%d", _second/10] forState:UIControlStateNormal];
    [_hourView2 setTitle:[NSString stringWithFormat:@"%d", _hour%10] forState:UIControlStateNormal];
    [_minuteView2 setTitle:[NSString stringWithFormat:@"%d", _minute%10] forState:UIControlStateNormal];
    [_secondView2 setTitle:[NSString stringWithFormat:@"%d", _second%10] forState:UIControlStateNormal];
    if (_countDownTimeInterval > 0 && !_timer) {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)setLabelBorderColor:(UIColor *)labelBorderColor {
    _hourView1.layer.borderColor = _minuteView1.layer.borderColor = _secondView1.layer.borderColor = labelBorderColor.CGColor;
    _hourView1.layer.borderWidth = _minuteView1.layer.borderWidth = _secondView1.layer.borderWidth = 0.5;
    _hourView2.layer.borderColor = _minuteView2.layer.borderColor = _secondView2.layer.borderColor = labelBorderColor.CGColor;
    _hourView2.layer.borderWidth = _minuteView2.layer.borderWidth = _secondView2.layer.borderWidth = 0.5;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(adjustCoundDownTimer:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)adjustCoundDownTimer:(NSTimer *)timer {
    _countDownTimeInterval --;
    if (_minute == 0 && _hour > 0) {
        _hour -= 1;
        _minute = 60;
        [_hourView1 setTitle:[NSString stringWithFormat:@"%d", _hour/10] forState:UIControlStateNormal];
        [_hourView2 setTitle:[NSString stringWithFormat:@"%d", _hour%10] forState:UIControlStateNormal];
    }
    
    if (_second == 0 && _minute > 0) {
        _second = 60;
        if (_minute > 0) {
            _minute -= 1;
            [_minuteView1 setTitle:[NSString stringWithFormat:@"%d", _minute/10] forState:UIControlStateNormal];
            [_minuteView2 setTitle:[NSString stringWithFormat:@"%d", _minute%10] forState:UIControlStateNormal];
        }
    }
    
    if (_second > 0) {
        _second -= 1;
        [_secondView1 setTitle:[NSString stringWithFormat:@"%d", _second/10] forState:UIControlStateNormal];
        [_secondView2 setTitle:[NSString stringWithFormat:@"%d", _second%10] forState:UIControlStateNormal];
    }
    
    if (_second <= 0 && _minute <= 0 && _hour <= 0) {
        [_timer invalidate];
        _timer = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(countDownDidFinished)]) {
            [_delegate countDownDidFinished];
        }
    }
}

- (void)stopCountDown {
    [self removeObservers];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark Observers and methods

- (void)observeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    _didRegisterNotificaton = YES;
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _didRegisterNotificaton = NO;
}

- (void)didInBackground:(NSNotification *)notification {
    _endBackgroundTimeInterval = [[NSDate date] timeIntervalSince1970];
    _countDownLeftTimeInterval = _countDownTimeInterval;
}

- (void)willEnterForground:(NSNotification *)notification {
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = currentTimeInterval - _endBackgroundTimeInterval;
    [self setCountDownTimeInterval:_countDownLeftTimeInterval - diff];
}

- (void)dealloc {
    [self removeObservers];
}

@end
