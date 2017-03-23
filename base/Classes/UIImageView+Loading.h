//
//  UIImageView+Loading.h
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BaseImageLoadCompletion)(UIImage *_Nullable);

@interface UIImageView (Loading)

- (void)az_setImageWithURL:(NSURL *)URL placeholderImage:(nullable UIImage *)image completion:(nullable BaseImageLoadCompletion)completion;

/// 默认铺满颜色为@LoadingPlaceholderColorHex的图片
- (void)setImageWithDefaultPlaceholder;

- (void)setImageWithProductPlaceholder;

- (void)setProductImageWithURL:(NSURL *)URL;
- (void)setImageUsingDefaultPlaceholderWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
