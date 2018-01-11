//
//  UIFont+LQFont.h
//  Pods
//
//  Created by Jocer on 2018/1/10.
//

#import <UIKit/UIKit.h>

typedef NSString * FontName;

FOUNDATION_EXTERN FontName const Ordinary;
FOUNDATION_EXTERN FontName const OrdinaryBold;
FOUNDATION_EXTERN FontName const FunctionProBook;
FOUNDATION_EXTERN FontName const FunctionProDemi;
FOUNDATION_EXTERN FontName const FunctionProMedium;
FOUNDATION_EXTERN FontName const FunctionProOblique;
FOUNDATION_EXTERN FontName const LibreBaskervilleRegular;

@interface UIFont (LQFont)

+ (UIFont *)dynamic_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
