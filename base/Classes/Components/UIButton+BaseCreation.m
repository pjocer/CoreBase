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
#import "util.h"
#import "UIFont+LQFont.h"
#import <QMUIKit/QMUICore.h>

NSUInteger const PrimaryButtonBackgroundColorHex = 0xe8437b;
NSUInteger const PrimaryButtonDisabledBackgroundColorHex = 0xcccccc;
NSUInteger const PrimaryButtonHighlightedBackgroundColorHex = 0xdc356f;

NSUInteger const LPPrimaryButtonBackgroundColorHex = 0xE73A8F;   //0xEF6767;
NSUInteger const LPPrimaryButtonHighlightedBackgroundColorHex = 0xd73384;

@implementation UIButton (BaseCreation)

+ (UIButton *)primaryButton {
    
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
    UIFont *font = nil;
    UIColor *normal = nil;
    UIColor *highlited = nil;
    UIColor *disabled = nil;
    
    if (IS_AZAZIE) {
        font = [UIFont dynamic_fontWithName:Ordinary size:UIFontLargeSize];
        normal = [UIColor tx_colorWithHex:PrimaryButtonBackgroundColorHex];
        highlited = [UIColor tx_colorWithHex:PrimaryButtonHighlightedBackgroundColorHex];
        disabled = [UIColor tx_colorWithHex:PrimaryButtonDisabledBackgroundColorHex];
    }
    
    if (IS_LOVEPROM) {
        font = [UIFont dynamic_fontWithName:FunctionProDemi size:UIFontLargeSize];
        normal = [UIColor tx_colorWithHex:LPPrimaryButtonBackgroundColorHex];
        highlited = [UIColor tx_colorWithHex:LPPrimaryButtonHighlightedBackgroundColorHex];
        disabled = [UIColor tx_colorWithHex:PrimaryButtonDisabledBackgroundColorHex];
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setBackgroundImage:[UIImage tx_imageWithColor:normal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:highlited] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage tx_imageWithColor:disabled] forState:UIControlStateDisabled];
    return btn;
}

@end
