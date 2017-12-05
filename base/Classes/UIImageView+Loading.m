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
#import "UIView+LoadingIndicator.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIImageView (Loading)

+ (UIImage *)defaultPlaceholderImage
{
    return [[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:LoadingPlaceholderColorHex]] tx_centerResizingImage];
}

+ (UIImage *)productPlaceholderImage
{
    return BaseImageWithNamed(@"product_placeholder");
}

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)image showLoadingIndicator:(BOOL)showLoadingIndicator completion:(BaseImageLoadCompletion)completion
{
    if (showLoadingIndicator)
    {
        [self startLoading];
    }
    
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    SDWebImageOptions option = SDWebImageCacheMemoryOnly|SDWebImageRetryFailed|SDWebImageRefreshCached;
    @weakify(self);
    [self sd_setImageWithPreviousCachedImageWithURL:URL placeholderImage:image options:option progress:NULL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [[UIApplication sharedApplication] hideNetworkActivityIndicator];
        main_thread_safe(^{
            @strongify(self);
            [self stopLoading];
            if (completion)
            {
                completion(image);
            }
        });
    }];
}

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)image completion:(void (^)(UIImage * _Nullable))completion
{
    [self az_setImageWithURL:URL placeholderImage:image showLoadingIndicator:NO completion:completion];
}

- (void)setImageWithDefaultPlaceholder
{
    self.image = [UIImageView defaultPlaceholderImage];
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
    [self az_setImageWithURL:URL placeholderImage:[UIImageView defaultPlaceholderImage] completion:NULL];
}

@end
