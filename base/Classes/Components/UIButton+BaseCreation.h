//
//  UIButton+BaseCreation.h
//  base
//
//  Created by Demi on 08/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSUInteger const PrimaryButtonBackgroundColorHex; // e8437b
UIKIT_EXTERN NSUInteger const PrimaryButtonDisabledBackgroundColorHex; // 0xcccccc
UIKIT_EXTERN NSUInteger const PrimaryButtonHighlightedBackgroundColorHex; // dc356f

UIKIT_EXTERN NSUInteger const LPPrimaryButtonBackgroundColorHex;
UIKIT_EXTERN NSUInteger const LPPrimaryButtonHighlightedBackgroundColorHex;

@interface UIButton (BaseCreation)

+ (UIButton *)primaryButton;
+ (UIButton *)primaryButtonForLP;

@end
