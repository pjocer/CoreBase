//
//  UIImageView+BaseGIF.m
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIImageView+BaseGIF.h"
#import "UIImage+BaseGIF.h"

@implementation UIImageView (BaseGIF)

+ (instancetype)imageViewWithLoadingGIF
{
    return [[self alloc] initWithImage:[UIImage loadingGIF]];
}

@end
