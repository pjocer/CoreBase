//
//  UIButton+BaseCreation.m
//  base
//
//  Created by Demi on 08/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIButton+BaseCreation.h"
#import <TXFire/TXFire.h>
#import "UIColor+BaseStyle.h"
#import "UIFont+BaseStyle.h"

NSUInteger const PrimaryButtonBackgroundColorHex = 0xe8437b;
NSUInteger const PrimaryButtonDisabledBackgroundColorHex = 0xcccccc;
NSUInteger const PrimaryButtonHighlightedBackgroundColorHex = 0xdc356f;

NSUInteger const LPPrimaryButtonBackgroundColorHex = 0xef6767;
NSUInteger const LPPrimaryButtonHighlightedBackgroundColorHex = 0xdd5757;

@implementation UIButton (BaseCreation)

+ (UIButton *)primaryButton
{
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:UIFontLargeSize];
    
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:PrimaryButtonBackgroundColorHex]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:PrimaryButtonHighlightedBackgroundColorHex]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:PrimaryButtonDisabledBackgroundColorHex]] forState:UIControlStateDisabled];
    return btn;
}

+ (UIButton *)primaryButtonForLP {
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:UIFontLargeSize];
    
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:LPPrimaryButtonBackgroundColorHex]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:LPPrimaryButtonHighlightedBackgroundColorHex]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:PrimaryButtonDisabledBackgroundColorHex]] forState:UIControlStateDisabled];
    return btn;
}

@end
