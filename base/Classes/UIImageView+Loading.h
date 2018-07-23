//
//  UIImageView+Loading.h
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BaseImageLoadCompletion)(UIImage *_Nullable image);

@interface UIImageView (Loading)

/// 默认铺满颜色为@LoadingPlaceholderColorHex的图片
+ (UIImage *)defaultPlaceholderImage;
+ (UIImage *)defaultCirclePlaceholderImage;
+ (UIImage *)productPlaceholderImage;

- (void)az_setImageWithURL:(NSURL *)URL
          placeholderImage:(nullable UIImage *)image
      showLoadingIndicator:(BOOL)showLoadingIndicator
                completion:(nullable BaseImageLoadCompletion)completion;

/// No loading indicator
- (void)az_setImageWithURL:(NSURL *)URL
          placeholderImage:(nullable UIImage *)image
                completion:(nullable BaseImageLoadCompletion)completion;

/// Loading with signal
- (void)az_setImageWithSignal:(RACSignal <NSURL *>*)aSignal
          placeholderImage:(nullable UIImage *)image
                completion:(nullable BaseImageLoadCompletion)completion;

- (void)setProductImageWithURL:(NSURL *)URL;
- (void)setImageUsingDefaultPlaceholderWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
