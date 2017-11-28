//
//  CyberMondayCountDownView.m
//  mobile
//
//  Created by Jocer on 2017/11/2.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "CyberMondayCountDownView.h"
#import "ActivityHandler.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <TXFire/TXFire.h>
#import <QMUIKit/QMUIKit.h>
#import "RouterManager.h"

@interface CyberMondayCountDownView ()
@property (nonatomic, strong) UIView *presaleContentView;
@property (nonatomic, strong) UILabel *presaleLabel;
@property (nonatomic, strong) UIButton *presaleClose;
@property (nonatomic, strong) UIView *cyberContentView;
@property (nonatomic, strong) UIView *cyberDescription;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *countDownImageView;
@property (nonatomic, strong) UILabel *countDownLabel;
@end

@implementation CyberMondayCountDownView

+ (instancetype)scheduledView {
    CyberMondayCountDownView *view = [[CyberMondayCountDownView alloc] init];
    return view.configureSelf.commitSubviews.makeConstraints.subscribe;
}

- (instancetype)configureSelf {
    self.userInteractionEnabled = YES;
    return self;
}

- (instancetype)commitSubviews{
    [self addSubview:self.presaleContentView];
    [self.presaleContentView addSubview:self.presaleLabel];
    [self.presaleContentView addSubview:self.presaleClose];
    [self addSubview:self.cyberContentView];
    [self.cyberContentView addSubview:self.cyberDescription];
    [self.cyberDescription addSubview:self.descriptionLabel];
    [self.cyberDescription addSubview:self.countDownImageView];
    [self.cyberDescription addSubview:self.countDownLabel];
    return self;
}

- (instancetype)makeConstraints {
    @weakify(self);
    [self.presaleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self);
    }];
    [self.presaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.presaleContentView);
        make.left.equalTo(self).offset(35);
        make.right.equalTo(self).offset(-35);
    }];
    [self.presaleClose mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.equalTo(self.presaleContentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.cyberContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.presaleContentView);
        make.top.equalTo(self.presaleContentView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    [self.cyberDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.cyberContentView);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self.cyberDescription);
    }];
    [self.countDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.top.bottom.equalTo(self.cyberDescription);
        make.left.equalTo(self.descriptionLabel.mas_right);
    }];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.top.bottom.equalTo(self.countDownImageView);
        make.left.equalTo(self.countDownImageView).offset(3);
    }];
    [self resetPreSaleViewAnimate:YES];
    [self resetCyberMondayViewAnimate:YES];
    return self;
}
- (instancetype)subscribe {
    @weakify(self);
    RACSignal *countDown = [[[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] startWith:NSDate.date] publish] autoconnect];
    RACSignal *presaleClose = [[self.presaleClose rac_signalForControlEvents:UIControlEventTouchUpInside] mapReplace:@(NO)];
    
    [self.rac_deallocDisposable addDisposable:[[countDown filter:^BOOL(id  _Nullable value) {
        return [[ActivityHandler sharedHandler] isCyberMondayViewAvaliable];
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSDateFormatter *fmt = [ActivityHandler sharedHandler].fmt;
        NSDate *endTime = [fmt dateFromString:CyberMondayCountDownEndTime];
        NSInteger timeInterval = floor([endTime timeIntervalSinceDate:x]);
        NSMutableString *hour = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%02ld", timeInterval/3600]];
        [hour insertString:@" " atIndex:1];
        NSMutableString *minute = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%02ld", timeInterval%3600/60]];
        [minute insertString:@" " atIndex:1];
        NSMutableString *second = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%02ld", timeInterval%60]];
        [second insertString:@" " atIndex:1];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@  %@",hour, minute, second] attributes:@{NSKernAttributeName:@1.f, NSFontAttributeName:UIFontBoldMake(13), NSForegroundColorAttributeName : [UIColor tx_colorWithHex:0x333333]}];
        [self.countDownLabel setAttributedText:attrS];
    }]];
    [self.rac_deallocDisposable addDisposable:[[countDown filter:^BOOL(id  _Nullable value) {
        return [[ActivityHandler sharedHandler] isPreSaleViewAvaliable] && !ActivityHandler.sharedHandler.hasClosedPreSaleView;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSDateFormatter *fmt = [ActivityHandler sharedHandler].fmt;
        NSDate *endTime = [fmt dateFromString:PreSaleCountDownEndTime];
        NSInteger timeInterval = floor([endTime timeIntervalSinceDate:NSDate.date]);
        timeInterval = timeInterval/(3600*24);
        NSString *text = nil;
        NSString *note = @"Note: Production times may increase";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];
        if (timeInterval == 0) {
            text = @"10% off your entire order today* | Note: Production times may increase";
        } else if (timeInterval == 1) {
            text = @"1 DAY UNTIL CYBER MONDAY | Note: Production times may increase";
        } else {
            text = [NSString stringWithFormat:@"%ld DAYS UNTIL CYBER MONDAY | Note: Production times may increase", timeInterval];
        }
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        NSMutableAttributedString *new = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
        [new addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[text rangeOfString:note]];
        [new addAttribute:NSUnderlineColorAttributeName value:UIColorMakeWithHex(@"#333333") range:NSMakeRange(0, text.length)];
        [self.presaleLabel setAttributedText:new];
        self.presaleLabel.textAlignment = NSTextAlignmentCenter;
    }]];
    [self.rac_deallocDisposable addDisposable:[[[countDown map:^id _Nullable(id  _Nullable value) {
        return @([[ActivityHandler sharedHandler] isCyberMondayViewAvaliable]);
    }] distinctUntilChanged] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        [self resetCyberMondayViewAnimate:!x.boolValue];
    }]];
    
    [self.rac_deallocDisposable addDisposable:[[[[countDown merge:presaleClose] map:^id _Nullable(id  _Nullable value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            [[ActivityHandler sharedHandler] setHasClosedPreSaleView:YES];
            return value;
        } else {
            if ([[ActivityHandler sharedHandler] hasClosedPreSaleView]) {
                return @(NO);
            } else {
                return @([[ActivityHandler sharedHandler] isPreSaleViewAvaliable]);
            }
        }
    }] distinctUntilChanged] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        [self resetPreSaleViewAnimate:!x.boolValue];
    }]];
    
    [self.presaleContentView.tx_tapGestureRecognizer.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        UIViewController *vc = [RouterManager.sharedManager request:[[RouterRequest alloc] initWithURL:[NSURL URLWithString:@"https://support.azazie.com/hc/en-us/articles/115005449083"] parameters:nil]];
        [[QMUIHelper visibleViewController].navigationController pushViewController:vc animated:YES];
    }];
    return self;
}

- (void)resetCyberMondayViewAnimate:(BOOL)hidden {
    @weakify(self);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        self.cyberContentView.alpha = hidden?0:1;
        [self.cyberContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hidden?0:30);
        }];
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)resetPreSaleViewAnimate:(BOOL)hidden {
    @weakify(self);
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        @strongify(self);
        self.presaleContentView.alpha = hidden?0:1;
        [self.presaleContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hidden?0:50);
        }];
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (UIView *)presaleContentView {
    if (!_presaleContentView) {
        _presaleContentView = [[UIView alloc] init];
        _presaleContentView.backgroundColor = [UIColor tx_colorWithHex:0xFDE2EC];
    }
    return _presaleContentView;
}

- (UILabel *)presaleLabel {
    if (!_presaleLabel) {
        _presaleLabel = [[UILabel alloc] initWithFont:UIFontMake(12) textColor:UIColorMakeWithHex(@"#333333")];
        _presaleLabel.numberOfLines = 2;
        _presaleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _presaleLabel;
}

- (UIButton *)presaleClose {
    if (!_presaleClose) {
        _presaleClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presaleClose setImage:UIImageMake(@"home_coupon_close") forState:UIControlStateNormal];
    }
    return _presaleClose;
}

- (UIView *)cyberContentView {
    if (!_cyberContentView) {
        _cyberContentView = [[UIView alloc] init];
        _cyberContentView.backgroundColor = [UIColor tx_colorWithHex:0x333333];
    }
    return _cyberContentView;
}

- (UIView *)cyberDescription {
    if (!_cyberDescription) {
        _cyberDescription = [[UIView alloc] init];
        _cyberDescription.backgroundColor = UIColorClear;
    }
    return _cyberDescription;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFont:UIFontMake(10) textColor:UIColorWhite];
        _descriptionLabel.text = @"CYBER MONDAY sale will end in";
    }
    return _descriptionLabel ;
}

- (UIImageView *)countDownImageView {
    if (!_countDownImageView) {
        _countDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_count_down"]];
    }
    return _countDownImageView;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countDownLabel;
}

@end
