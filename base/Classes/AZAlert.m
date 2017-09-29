//
//  AZAlert.m
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "AZAlert.h"
#import "UIView+SeparatorLine.h"
#import <QMUIKit.h>
#import <Masonry.h>
#import <ReactiveObjC.h>

#define animate_duration 0.3

@interface AZAlert ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UIView *titleLabel;
@property (nonatomic, strong) UIView *detailLabel;
@property (nonatomic, strong) UIView *footerSeparator;
@property (nonatomic, strong) NSMutableArray <QMUIButton *>*items;
@end

@implementation AZAlert

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AZAlert *alert = nil;
    dispatch_once(&onceToken, ^{
        alert = [AZAlert new];
    });
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title detailText:(NSString *)detail {
    AZAlert *alert = [AZAlert sharedInstance];
    alert.items = [NSMutableArray array];
    
    alert.contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorWhite;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.hidden = YES;
        view;
    });
    
    alert.maskView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorBlack;
        view.alpha = 0;
        view;
    });
    
    alert.header = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = PHImageContentModeAspectFit;
        view.hidden = YES;
        view;
    });
    
    alert.titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFont:UIFontBoldMake(18) textColor:UIColorMakeWithHex(@"#333333")];
        label.text = title;
        label;
    });
    
    alert.detailLabel = ({
        UILabel *label = [[UILabel alloc] initWithFont:UIFontMake(12) textColor:UIColorMakeWithHex(@"#333333")];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [label setQmui_lineHeight:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = detail;
        label;
    });
    
    alert.footerSeparator = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorMakeWithHex(@"#dcdcdc");
        label;
    });
    
    [alert.contentView addSubview:alert.titleLabel];
    [alert.contentView addSubview:alert.detailLabel];
    [alert.contentView addSubview:alert.footerSeparator];
    
    [alert.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(48);
        make.centerX.equalTo(alert.contentView);
    }];
    
    [alert.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.titleLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
    }];
    
    [alert.footerSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.detailLabel.mas_bottom).offset(32);
        make.left.right.equalTo(alert.contentView);
        make.height.mas_equalTo(1);
    }];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:alert.maskView];
    [window addSubview:alert.contentView];
    [window addSubview:alert.header];
    
    [alert.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.equalTo(alert.contentView).offset(-30);
        make.centerX.equalTo(window);
    }];
    [alert.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [alert.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.width.mas_equalTo(295);
    }];
    return alert;
}

- (void)addHeaderImage:(UIImage *)img {
    if (!img) {
        return;
    }
    self.header.image = img;
}

- (void)addCancelItemWithTitleAttributes:(NSDictionary *)attr title:(NSString *)title action:(dispatch_block_t)action {
    [self addItemWithTitleAttributes:attr title:title action:action];
}

- (void)addConfirmItemWithTitleAttributes:(NSDictionary *)attr title:(NSString *)title action:(dispatch_block_t)action {
    [self addItemWithTitleAttributes:attr title:title action:action];
}

- (void)addItemWithTitleAttributes:(NSDictionary *)attr title:(NSString *)title action:(dispatch_block_t)action {
    QMUIButton *item = [QMUIButton buttonWithType:UIButtonTypeCustom];
    item.titleLabel.font = UIFontBoldMake(15);
    if (attr) {
        [item setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attr] forState:UIControlStateHighlighted];
        [item setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attr] forState:UIControlStateNormal];
    } else {
        [item setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
        [item setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateHighlighted];
    }
    [self.items addObject:item];
    [self drawFooterItemsIfNeeded];
    @weakify(self);
    [[item rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self dissmissWithAnimated:YES completion:^{
            if (action) action();
        }];
    }];
}

- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete {
    if (animated) {
        self.contentView.hidden = NO;
        self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.contentView.alpha = 0;
        if (self.header.image) {
            self.header.hidden = NO;
            self.header.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.header.alpha = 0;
        }
        [UIView animateWithDuration:animate_duration delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:20.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.maskView.alpha = 0.3;
            self.contentView.transform = CGAffineTransformIdentity;
            self.contentView.alpha = 1;
            if (self.header.image) {
                self.header.transform = CGAffineTransformIdentity;
                self.header.alpha = 1;
            }
        } completion:^(BOOL finished) {
            if (complete) complete();
        }];
    } else {
        self.contentView.hidden = NO;
        self.header.hidden = NO;
        self.maskView.alpha = 0.3;
        if (complete) complete();
    }
}

- (void)dissmissWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete {
    if (animated) {
        [UIView animateWithDuration:animate_duration animations:^{
            self.maskView.alpha = 0;
            self.contentView.alpha = 0;
            self.header.alpha = 0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.contentView removeFromSuperview];
            [self.header removeFromSuperview];
            if (complete) complete();
        }];
    } else {
        [self.maskView removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self.header removeFromSuperview];
        if (complete) complete();
    }
}

- (void)drawFooterItemsIfNeeded {
    NSUInteger count = self.items.count;
    __block UIButton *lastButton = nil;
    [self.items enumerateObjectsUsingBlock:^(QMUIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.superview) {
            [self.contentView addSubview:obj];
        }
        if (lastButton) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lastButton.mas_trailing);
                make.top.bottom.height.equalTo(lastButton);
                make.width.equalTo(self.contentView).dividedBy(count);
            }];
            [obj drawSeparatorLineToPosition:UIRectEdgeLeft lineWidth:1];
        } else {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView);
                make.top.equalTo(self.footerSeparator.mas_bottom);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(49);
                make.width.equalTo(self.contentView).dividedBy(count);
            }];
        }
        lastButton = obj;
    }];
}

@end
