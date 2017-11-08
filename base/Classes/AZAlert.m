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
#import "AZProgressHUD.h"

#define animate_duration 0.3

@interface AZAlert ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray <UIView *>*detailLabels;
@property (nonatomic, strong) UIView *footerSeparator;
@property (nonatomic, strong) NSMutableArray <QMUIButton *>*items;
@property (nonatomic, assign) BOOL preferred;
@property (nonatomic, weak) AZProgressHUD *hud;
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

+ (instancetype)alertWithTitle:(NSString *)title detailText:(NSString *)detail preferConfirm:(BOOL)preferred {
    return [self alertWithTitle:title detailTexts:detail?@[detail]:@[] preferConfirm:preferred];
}

+ (instancetype)alertWithTitle:(NSString *)title detailTexts:(NSArray<NSString *> *)details preferConfirm:(BOOL)preferred {
    AZAlert *alert = [AZAlert sharedInstance];
    alert.items = [NSMutableArray array];
    alert.preferred = preferred;
    
    alert.contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorClear;
        view;
    });
    
    alert.alertView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorWhite;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
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
    
    alert.detailLabels = ({
        details = details.count==0?@[@"Unknow details describtion"]:details;
        NSMutableArray *labels = [NSMutableArray arrayWithCapacity:details.count];
        if (details.count == 1) {
            [labels addObject:[alert generateNormalLabelWithText:details.firstObject]];
        } else {
            [details enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [labels addObject:[alert generateNormalLabelWithText:[NSString stringWithFormat:@"•  %@",obj]]];
            }];
        }
        labels;
    });
    
    alert.footerSeparator = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorMakeWithHex(@"#dcdcdc");
        label;
    });
    [alert handleConstraintsForSubViews];
    return alert;
}

- (void)handleConstraintsForSubViews {
    [self.contentView addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.alertView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(48);
        make.centerX.equalTo(self.alertView);
    }];
    NSUInteger count = self.detailLabels.count;
    __block UIView *last = nil;
    [self.detailLabels enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.superview) {
            [self.alertView addSubview:obj];
        }
        if (last) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(last.mas_bottom);
                make.left.right.equalTo(last);
            }];
        } else {
            UILabel *subtitle = [self generateNormalLabelWithText:[NSString stringWithFormat:@"We find %ld problems below:",count]];
            [self.alertView addSubview:subtitle];
            
            [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(40);
                make.trailing.mas_equalTo(-40);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            }];
            subtitle.hidden = count==1;
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(subtitle);
                make.top.equalTo(subtitle.hidden?self.titleLabel.mas_bottom:subtitle.mas_bottom).offset(subtitle.hidden?10:0);
            }];
        }
        last = obj;
    }];
    
    [self.alertView addSubview:self.footerSeparator];
    [self.footerSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self.detailLabels lastObject].mas_bottom).offset(32);
        make.left.right.equalTo(self.alertView);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)generateNormalLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFont:UIFontMake(12) textColor:UIColorMakeWithHex(@"#333333")];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label setQmui_lineHeight:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}

- (void)addHeaderImage:(UIImage *)img {
    if (!img) {
        return;
    }
    self.header.hidden = NO;
    self.header.image = img;
}

- (void)addCancelItemWithTitle:(NSString *)title action:(dispatch_block_t)action {
    [self addItemWithTitleAttributes:@{NSForegroundColorAttributeName:self.preferred?UIColorMakeWithHex(@"#333333"):UIColorMakeWithHex(@"#E8437B")} title:title action:action];
}

- (void)addConfirmItemWithTitle:(NSString *)title action:(dispatch_block_t)action {
    [self addItemWithTitleAttributes:@{NSForegroundColorAttributeName:self.preferred?UIColorMakeWithHex(@"#E8437B"):UIColorMakeWithHex(@"#333333")} title:title action:action];
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
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitle:title forState:UIControlStateHighlighted];
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

- (void)show {
    [self showWithAnimated:YES completion:NULL];
}

- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete {
    if (self.hud) {
        [self.hud hide];
    }
    self.hud = AZProgressHUD.hud.grace(0.5f).contentView(self.contentView).coverredWindow(YES).minContentSize(CGSizeMake(295, 195));
    if (!animated) {
        self.hud.displayAnimationType(AZProgressHUDAnimationTypeDefault);
    }
    [self.hud show];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (complete) complete();
}

- (void)dissmissWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete {
    if (!animated) {
        self.hud.hiddenAnimationType(AZProgressHUDAnimationTypeDefault);
    }
    [self.hud hide];
    if (complete) complete();
}

- (void)drawFooterItemsIfNeeded {
    NSUInteger count = self.items.count;
    __block UIButton *lastButton = nil;
    [self.items enumerateObjectsUsingBlock:^(QMUIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.superview) {
            [self.alertView addSubview:obj];
        }
        if (lastButton) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lastButton.mas_trailing);
                make.top.bottom.height.equalTo(lastButton);
                make.width.equalTo(self.alertView).dividedBy(count);
            }];
            [obj drawSeparatorLineToPosition:UIRectEdgeLeft lineWidth:1];
        } else {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.alertView);
                make.top.equalTo(self.footerSeparator.mas_bottom);
                make.bottom.equalTo(self.alertView);
                make.height.mas_equalTo(49);
                make.width.equalTo(self.alertView).dividedBy(count);
            }];
        }
        lastButton = obj;
    }];
}

@end
