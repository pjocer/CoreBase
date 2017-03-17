//
//  UIImage+BaseGIF.h
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BaseGIF)

+ (nullable UIImage *)GIFAnimatedImageWithContentsOfFile:(NSString *)path;

+ (UIImage *)loadingGIF;

@end

NS_ASSUME_NONNULL_END
