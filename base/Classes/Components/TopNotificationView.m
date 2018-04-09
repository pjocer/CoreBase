//
//  TopNotificationLabel.m
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import "TopNotificationView.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "NotificationLoader.h"
#import <TXFire/UIView+TXFire.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIFont+LQFont.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>

@interface TopNotificationView ()
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) UIButton *close;
@end

@implementation TopNotificationView

- (instancetype)initWithData:(TopNotificationModel *)data {
    if (self = [super init]) {
        self.model = data;
        [self subscribe];
    }
    return self;
}

- (void)subscribe {
    @weakify(self);
    [[self.tx_tapGestureRecognizer.rac_gestureSignal map:^id _Nullable(__kindof UIGestureRecognizer * _Nullable value) {
        @strongify(self);
        CGPoint point = [value locationInView:self.label];
        TTTAttributedLabelLink *link = [self.label linkAtPoint:point];
        return link;
    }] subscribeNext:^(TTTAttributedLabelLink * _Nullable x) {
        @strongify(self);
        if (x) {
            if (self.clickedLink) self.clickedLink(x.result.URL);
        } else {
            if (self.clickedAction) self.clickedAction();
        }
    }];
    [[RACObserve(self, model) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.backgroundColor = UIColorMakeWithHex(self.model.background_color?:@"#fd7ea9");
        self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.lineSpacing = 6;
        self.label.textAlignment = self.model.alignment;
        self.label.font = UIFontMake(self.model.font_size?:12);
        self.label.textColor = UIColorMakeWithHex(@"#333333");
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.model.text];
        TopNotificationAttributesModel *href = nil;
        for (TopNotificationAttributesModel *attribute in self.model.attributes) {
            __block NSDictionary *attr = nil;
            switch (attribute.type) {
                case TopNotifyLabelAttributesTypeFontColor: {
                    NSRange range = attribute.effect_range;
                    NSDictionary *dic = [text attributesAtIndex:0 effectiveRange:&range];
                    if (dic && dic[NSUnderlineStyleAttributeName]) {
                        attr = @{NSForegroundColorAttributeName : UIColorMakeWithHex(attribute.value),
                                 NSUnderlineColorAttributeName : UIColorMakeWithHex(attribute.value)
                                 };
                    } else {
                        attr = @{NSForegroundColorAttributeName : UIColorMakeWithHex(attribute.value)
                                 };
                    }
                }
                    break;
                case TopNotifyLabelAttributesTypeBold:{
                    if ([attribute.value boolValue]) {
                        attr = @{NSFontAttributeName : UIFontBoldMake(self.model.font_size)};
                    }
                }
                    break;
                case TopNotifyLabelAttributesTypeUnderline:{
                    NSRange range = attribute.effect_range;
                    NSDictionary *dic = [text attributesAtIndex:0 effectiveRange:&range];
                    if (dic && dic[NSForegroundColorAttributeName]) {
                        attr = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName : dic[NSForegroundColorAttributeName]
                                 };
                    } else {
                        attr = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
                    }
                }
                    break;
                case TopNotifyLabelAttributesTypeHref:{
                    href = attribute;
                }
                    break;
                default:
                    break;
            }
            if (attr) {
                [text addAttributes:attr range:attribute.effect_range];
            }
        }
        self.label.text = text;
        if (href) {
            NSRange range = href.effect_range;
            NSMutableDictionary *attributes = [[self.label.attributedText attributesAtIndex:range.location effectiveRange:&range] mutableCopy];
            self.label.linkAttributes = attributes;
            attributes[NSForegroundColorAttributeName] = UIColorRed;
            self.label.activeLinkAttributes = attributes;
            self.label.inactiveLinkAttributes = attributes;
            [self.label addLinkToURL:[NSURL URLWithString:href.value] withRange:href.effect_range];
        }
        [self addSubview:self.label];
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.model.text ? 10 : 0);
            make.bottom.mas_equalTo(self.model.text ? -10 : 0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
        }];
        self.close = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.close setBackgroundImage:UIImageMake(@"nav_close") forState:UIControlStateNormal];
        [self addSubview:self.close];
        [self.close mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self.model.text ? 10 : 0);
            make.top.mas_equalTo(self.model.text ? 10 : 0);
            make.right.mas_equalTo(self.model.text ? 10 : 0);
        }];
        [[self.close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @weakify(self);
            NotificationSharedLoader.top_model = nil;
        }];
    }];
}

@end
