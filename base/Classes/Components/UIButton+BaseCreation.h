//
//  UIButton+BaseCreation.h
//  base
//
//  Created by Demi on 08/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSUInteger const PrimaryButtonBackgroundColorHex; // e8437b
UIKIT_EXTERN NSUInteger const PrimaryButtonDisabledBackgroundColorHex; // f8c7d7
UIKIT_EXTERN NSUInteger const PrimaryButtonHighlightedBackgroundColorHex; // dc356f

@interface UIButton (BaseCreation)

+ (UIButton *)primaryButton;

@end
