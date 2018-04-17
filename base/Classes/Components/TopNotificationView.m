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
@property (nonatomic, strong) UIImageView *close;
@end

@implementation TopNotificationView

- (instancetype)initWithData:(TopNotificationModel *)data {
    if (self = [super init]) {
        self.model = data;
        [self subscribe];
    }
    return self;
}

- (instancetype)init {
    return [self initWithData:nil];
}

- (instancetype)subscribe {
    @weakify(self);
    [[RACObserve(self, model) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.backgroundColor = UIColorMakeWithHex(self.model.background_color?:@"e8437b");
        [self renderDetailLabel];
        [self renderCloseButton];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
    
    [[self.tx_tapGestureRecognizer.rac_gestureSignal map:^id _Nullable(__kindof UIGestureRecognizer * _Nullable value) {
        @strongify(self);
        if (CGRectContainsPoint(self.label.bounds, [value locationInView:self.label])) {
            CGPoint point = [value locationInView:self.label];
            TTTAttributedLabelLink *link = [self.label linkAtPoint:point];
            return link;
        } else if (CGRectContainsPoint(self.close.bounds, [value locationInView:self.close])) {
            return self.close;
        } else {
            return nil;
        }
    }] subscribeNext:^(id  _Nullable x) {
        if (x == self.close) {
            NotificationSharedLoader.top_model = nil;
        } else if ([x isKindOfClass:TTTAttributedLabelLink.class]) {
            if (self.clickedLink) self.clickedLink([[(TTTAttributedLabelLink *)x result] URL]);
        } else {
            if (self.clickedAction) self.clickedAction();
        }
    }] ;
    return self;
}

static CGSize expectedSize;

+ (CGSize)expectedSize {
    TopNotificationModel *model = NotificationSharedLoader.top_model;
    if (!model) {
        return CGSizeZero;
    }
    if (!CGSizeIsEmpty(expectedSize)) {
        return expectedSize;
    }
    TTTAttributedLabel *label = [self getAttributedLabelWithData:model];
    CGSize s = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX)];
    s.height = ceilf(s.height) + 20;
    expectedSize = s;
    return expectedSize;
}

+ (TTTAttributedLabel *)getAttributedLabelWithData:(TopNotificationModel *)model {
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.lineSpacing = 6;
    label.textAlignment = model.alignment;
    label.font = UIFontMake(model.font_size);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
    NSMutableArray <TopNotificationAttributesModel *>*hrefs = [NSMutableArray array];
    for (TopNotificationAttributesModel *attribute in model.attributes) {
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
                    attr = @{NSFontAttributeName : UIFontBoldMake(model.font_size)};
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
                [hrefs addObject:attribute];
            }
                break;
            default:
                break;
        }
        if (attr) {
            [text addAttributes:attr range:attribute.effect_range];
        }
    }
    label.text = text;
    [hrefs enumerateObjectsUsingBlock:^(TopNotificationAttributesModel * _Nonnull href, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = href.effect_range;
        NSMutableDictionary *attributes = [[label.attributedText attributesAtIndex:range.location effectiveRange:&range] mutableCopy];
        label.linkAttributes = attributes;
        attributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"e8437b");
        label.activeLinkAttributes = attributes;
        label.inactiveLinkAttributes = attributes;
        [label addLinkToURL:[NSURL URLWithString:href.value] withRange:href.effect_range];
    }];
    return label;
}

- (void)renderCloseButton {
    if (!self.model.text) {
        [self.close removeFromSuperview];
        return;
    } else {
        if (!self.close.superview) {
            [self addSubview:self.close];
            [self.close mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(10);
                make.top.mas_equalTo(10);
                make.right.mas_equalTo(-10);
            }];
        }
    }
}

- (void)renderDetailLabel {
    if (!self.model.text) {
        [self.label removeFromSuperview];
        return;
    } else {
        if (!self.label.superview) {
            self.label = [self.class getAttributedLabelWithData:self.model];
            [self addSubview:self.label];
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.left.mas_equalTo(25);
                make.right.mas_equalTo(-25);
            }];
        }
    }
}

- (UIImageView *)close {
    if (!_close) {
        _close = [[UIImageView alloc] initWithImage:UIImageMake(@"cart_nav_close")];
    }
    return _close;
}

@end
