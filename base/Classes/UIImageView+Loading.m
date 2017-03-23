//
//  UIImageView+Loading.m
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIImageView+Loading.h"
#import <TXFire/TXFire.h>
#import <TXFire/UIApplication+TXFire.h>
#import "UIApplication+Base.h"
#import "UIColor+BaseStyle.h"
#import "util.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Loading)

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)image completion:(void (^)(UIImage * _Nullable))completion
{
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    [self sd_setImageWithURL:URL placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        main_thread_safe(^{
            if (completion)
            {
                completion(image);
            }
        });
        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
    }];
}

+ (UIImage *)tx_defaultPlaceholderImage
{
    return [[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:LoadingPlaceholderColorHex]] tx_centerResizingImage];
}

- (void)setImageWithDefaultPlaceholder
{
    self.image = [UIImageView tx_defaultPlaceholderImage];
}

- (void)setImageWithProductPlaceholder
{
    self.image = BaseImageWithNamed(@"product_placeholder");
}

- (void)setProductImageWithURL:(NSURL *)URL
{
    //[self sd_setImageWithURL:URL placeholderImage:BaseImageWithNamed(@"product_placeholder")];
    [self az_setImageWithURL:URL placeholderImage:BaseImageWithNamed(@"product_placeholder") completion:NULL];
}

- (void)setImageUsingDefaultPlaceholderWithURL:(NSURL *)URL
{
    [self az_setImageWithURL:URL placeholderImage:[UIImageView tx_defaultPlaceholderImage] completion:NULL];
}

@end
