//
//  UILabel+Loading.m
//  AFNetworking
//
//  Created by Jocer on 2018/7/23.
//

#import "UILabel+Loading.h"
#import <Masonry/Masonry.h>

@implementation UILabel (Loading)

- (void)az_setTextWithSignal:(RACSignal<NSString *> *)aSignal expectedWidth:(CGFloat)width color:(UIColor *)color {
    [self az_setTextWithSignal:aSignal expectedWidth:width alignment:NSTextAlignmentLeft color:color];
}

- (void)az_setTextWithSignal:(RACSignal<NSString *> *)aSignal expectedWidth:(CGFloat)width alignment:(NSTextAlignment)alignment color:(UIColor *)color {
    UIView *innet = [[UIView alloc] init];
    innet.backgroundColor = color;
    @weakify(self, innet);
    [[[aSignal deliverOn:[RACScheduler mainThreadScheduler]] initially:^{
        @strongify(self, innet);
        [self addSubview:innet];
        [innet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (alignment == NSTextAlignmentLeft) {
                make.left.equalTo(self);
            } else if (alignment == NSTextAlignmentRight) {
                make.right.equalTo(self);
            } else {
                make.centerX.equalTo(self);
            }
            make.width.mas_equalTo(width);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }] subscribeNext:^(NSString * _Nullable x) {
        @strongify(innet, self);
        [UIView animateWithDuration:0.15 animations:^{
            innet.alpha = 0;
            self.text = x;
        } completion:^(BOOL finished) {
            [innet removeFromSuperview];
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    }] ;
}

@end
