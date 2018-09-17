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
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import "UIView+LoadingIndicator.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <QMUIKit/QMUIKit.h>

@implementation UIImageView (Loading)

+ (UIImage *)defaultPlaceholderImage
{
    return [[UIImage tx_imageWithColor:[UIColor tx_colorWithHex:LoadingPlaceholderColorHex]] tx_centerResizingImage];
}

+ (UIImage *)defaultCirclePlaceholderImage {
    return [UIImage qmui_imageWithColor:[UIColor tx_colorWithHex:LoadingPlaceholderColorHex] size:CGSizeMake(100, 100) cornerRadius:50];
}

+ (UIImage *)productPlaceholderImage
{
    return BaseImageWithNamed(IS_AZAZIE?@"product_placeholder":@"product_placeholder_loveprom");
}

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)image showLoadingIndicator:(BOOL)showLoadingIndicator animation:(BOOL)animate completion:(nullable BaseImageLoadCompletion)completion {
    SDWebImageOptions option = SDWebImageQueryDataWhenInMemory|SDWebImageRetryFailed|SDWebImageRefreshCached|SDWebImageContinueInBackground|SDWebImageQueryDiskSync;

    @weakify(self);
    if ([[URL.absoluteString substringFromIndex:URL.absoluteString.length-3] isEqualToString:@"gif"]) {
        if (showLoadingIndicator) [self startLoading];
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        self.image = image;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:option progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            @strongify(self);
            main_thread_safe(^{
                [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                [self stopLoading];
                
                UIImage *gifImage = [UIImage sd_animatedGIFWithData:data];
                if ([gifImage isGIF]) {
                    self.image = gifImage;
                    if (completion) completion(gifImage);
                } else {
                    self.image = image;
                    if (completion) completion(image);
                }
            });
        }];
        
    } else {
        if (showLoadingIndicator) [self startLoading];
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        [self sd_setImageWithURL:URL placeholderImage:image options:option progress:NULL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            main_thread_safe(^{
                [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                [self stopLoading];
                
                if (completion) {
                    completion(image);
                }
            });
        }];
    }
}

- (void)az_setImageWithURL:(NSURL *)URL
          placeholderImage:(nullable UIImage *)image
      showLoadingIndicator:(BOOL)showLoadingIndicator
                completion:(nullable BaseImageLoadCompletion)completion {
    [self az_setImageWithURL:URL placeholderImage:image showLoadingIndicator:showLoadingIndicator animation:YES completion:NULL];
}

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)image completion:(void (^)(UIImage * _Nullable))completion {
    [self az_setImageWithURL:URL placeholderImage:image showLoadingIndicator:NO animation:YES completion:completion];
}
- (void)az_setImageWithSignal:(RACSignal <NSURL *>*)aSignal placeholderImage:(UIImage *)image completion:(BaseImageLoadCompletion)completion {
    @weakify(self);
    [[aSignal initially:^{
        @strongify(self);
        self.image = image;
    }] subscribeNext:^(NSURL * _Nullable x) {
        @strongify(self);
        [self az_setImageWithURL:x placeholderImage:image completion:completion];
    }];
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
