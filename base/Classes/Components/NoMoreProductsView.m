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
    tipLabel.text = @"There's no more items.";
    tipLabel.textColor = [UIColor tx_colorWithHex:0xcccccc];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipImageView.mas_bottom).offset(10);
        make.bottom.equalTo(self);
    }];
}

@end
