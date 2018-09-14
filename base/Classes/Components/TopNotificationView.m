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
#import "util.h"
#import "ActivityHandler.h"

@interface TopNotificationView ()
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) UIImageView *close;
@property (nonatomic, strong) UIView *closeContent;
@end

@implementation TopNotificationView

- (instancetype)init {
    if (self = [super init]) {
        [self subscribe];
    }
    return self;
}

- (instancetype)subscribe {
    @weakify(self);
    [[RACObserve(self, model) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.model.background_color) {
            self.backgroundColor = UIColorMakeWithHex(self.model.background_color);
        } else {
            self.backgroundColor = UIColorClear;
        }
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
        } else if (CGRectContainsPoint(self.closeContent.bounds, [value locationInView:self.closeContent])) {
            return self.closeContent;
        } else {
            return nil;
        }
    }] subscribeNext:^(id  _Nullable x) {
        if (x == self.closeContent) {
            if (self.clickedClose) {
                self.clickedClose();
            } else {
                NotificationSharedLoader.top_model = nil;
            }
        } else if ([x isKindOfClass:TTTAttributedLabelLink.class]) {
            if (self.clickedLink) self.clickedLink([[(TTTAttributedLabelLink *)x result] URL]);
        } else {
            if (self.clickedAction) self.clickedAction();
        }
    }] ;
    return self;
}

+ (CGSize)expectedSize:(TopNotificationModel *)model {
    if (!model) {
        return CGSizeZero;
    }
    TTTAttributedLabel *label = [self getAttributedLabelWithData:model];
    CGSize s = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-50, CGFLOAT_MAX)];
    s.height = ceilf(s.height) + 20;
    return s;
}

+ (TTTAttributedLabel *)getAttributedLabelWithData:(TopNotificationModel *)model {
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.lineSpacing = 6;
    label.textAlignment = model.alignment;
    if (!model.text) {
        return label;
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.text];
    [text addAttribute:NSFontAttributeName value:UIFontMake(model.font_size) range:NSMakeRange(0, model.text.length)];
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
        [self.closeContent removeFromSuperview];
        return;
    } else {
        if (!self.closeContent.superview) {
            [self addSubview:self.closeContent];
            [self.closeContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(20);
                make.top.mas_equalTo(5);
                make.right.mas_equalTo(-5);
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
                make.bottom.mas_equalTo(-10).priorityLow();
                make.left.mas_equalTo(25);
                make.right.mas_equalTo(-25);
            }];
        } else {
            [self.label removeFromSuperview];
            self.label = [self.class getAttributedLabelWithData:self.model];
            [self addSubview:self.label];
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10).priorityLow();
                make.left.mas_equalTo(25);
                make.right.mas_equalTo(-25);
            }];
        }
    }
}

- (UIView *)closeContent {
    if (!_closeContent) {
        _closeContent = [[UIView alloc] init].tx_backgroundColor(UIColorClear);
        
        [_closeContent addSubview:self.close];
        [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerX.equalTo(_closeContent);
            make.top.mas_equalTo(5);
        }];
    }
    return _closeContent;
}

- (UIImageView *)close {
    if (!_close) {
        _close = [[UIImageView alloc] initWithImage:BaseImageWithNamed(@"top_notification_close")];
    }
    return _close;
}

@end
