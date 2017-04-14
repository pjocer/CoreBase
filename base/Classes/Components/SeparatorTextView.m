//
//  SeparatorTextView.m
//  CoreUser
//
//  Created by Demi on 11/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "SeparatorTextView.h"
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>
#import "UIFont+BaseStyle.h"
#import "UIColor+BaseStyle.h"

@implementation SeparatorTextView

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
    UILabel *textLabel = [[UILabel alloc] init];
    _textLabel = textLabel;
    textLabel.font = [UIFont boldSystemFontOfSize:UIFontSmallSize];
    textLabel.textColor = [UIColor tx_colorWithHex:LightTextColorHex];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.and.bottom.equalTo(self);
        maker.centerX.equalTo(self);
    }];
    
    UIView *leftSeparator = [[UIView alloc] initWithFrame:CGRectZero].tx_backgroundColorHex(0xe1e1e1);
    [self addSubview:leftSeparator];
    [leftSeparator mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.leading.equalTo(self);
        maker.height.mas_equalTo(1.f);
        maker.centerY.equalTo(self);
        maker.trailing.equalTo(textLabel.mas_leading).offset(-10.f);
    }];
    
    UIView *rightSeparator = [[UIView alloc] initWithFrame:CGRectZero].tx_backgroundColorHex(0xe1e1e1);
    [self addSubview:rightSeparator];
    [rightSeparator mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.trailing.equalTo(self);
        maker.height.mas_equalTo(1.f);
        maker.centerY.equalTo(self);
        maker.leading.equalTo(textLabel.mas_trailing).offset(10.f);
    }];
}

@end
