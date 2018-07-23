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
    UIView *innet = [[UIView alloc] init];
    innet.backgroundColor = color;
    [self addSubview:innet];
    [innet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(width);
    }];
    @weakify(innet, self);
    [aSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(innet, self);
        [UIView animateWithDuration:0.15 animations:^{
            innet.alpha = 0;
            self.text = x;
        } completion:^(BOOL finished) {
            [innet removeFromSuperview];
        }];
    }];
}

@end
