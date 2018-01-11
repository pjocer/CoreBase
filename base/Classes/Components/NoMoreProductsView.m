//
//  NoMoreProductsView.m
//  mobile
//
//  Created by Demi on 07/04/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "NoMoreProductsView.h"
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>
#import "util.h"
#import "UIFont+LQFont.h"

const CGFloat NoMoreProductsViewExpectedHeight = 65.f;

@implementation NoMoreProductsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIImageView *tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_more_goods"]];
    [self addSubview:tipImageView];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(31, 40));
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = IS_AZAZIE ? @"There's no more items." : @"No more items";
    tipLabel.textColor = [UIColor tx_colorWithHex:0xcccccc];
    tipLabel.font = [UIFont dynamic_fontWithName:IS_AZAZIE?Ordinary:FunctionProBook size:IS_AZAZIE?13.f:15.f];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipImageView.mas_bottom).offset(10);
        make.bottom.equalTo(self);
    }];
}

@end
