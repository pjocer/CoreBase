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
    if (showLoadingIndicator) {
        [self startLoading];
    }
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    SDWebImageOptions option = SDWebImageQueryDataWhenInMemory|SDWebImageRetryFailed|SDWebImageRefreshCached|SDWebImageContinueInBackground|SDWebImageQueryDiskSync;
    @weakify(self);
    [self sd_setImageWithURL:URL placeholderImage:image options:option progress:NULL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        main_thread_safe(^{
            [[UIApplication sharedApplication] hideNetworkActivityIndicator];
            [self stopLoading];
            if (image && animate) {
                CATransition *transition = [CATransition animation];
                transition.type = kCATransitionFade;
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.layer addAnimation:transition forKey:nil];
            }
            if (completion) {
                completion(image);
            }
        });
    }];;
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
