//
//  UIView+LoadingIndicator.m
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIView+LoadingIndicator.h"
#import <TXFire/TXFire.h>
#import <TXFire/UIImage+TXGIF.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import "util.h"

@implementation UIView (LoadingIndicator)

static const void * kLoadingIndicatorView = &kLoadingIndicatorView;

- (UIImageView *)loadingIndicatorView
{
    return objc_getAssociatedObject(self, kLoadingIndicatorView);
}

- (void)setLoadingIndicatorView:(UIImageView * _Nullable)loadingIndicatorView
{
    objc_setAssociatedObject(self, kLoadingIndicatorView, loadingIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stopLoading
{
    UIImageView *loadingIndicatorView = self.loadingIndicatorView;
    if (loadingIndicatorView)
    {
        [loadingIndicatorView removeFromSuperview];
        self.loadingIndicatorView = nil;
    }
}

- (void)startLoading
{
    UIImageView *loadingIndicatorView = self.loadingIndicatorView;
    if (loadingIndicatorView)
    {
        if (!loadingIndicatorView.isAnimating)
        {
            [loadingIndicatorView startAnimating];
        }
    }
    else
    {
        loadingIndicatorView = [[UIImageView alloc] init];
        NSTimeInterval duration = 0;
        NSArray *images = [UIImage tx_gifImagesWithFile:BasePathForResource(@"loading", @"gif") totalDuration:&duration];
        loadingIndicatorView.animationImages = images;
        loadingIndicatorView.animationDuration = duration;
        loadingIndicatorView.animationRepeatCount = 0;
        [loadingIndicatorView startAnimating];
        self.loadingIndicatorView = loadingIndicatorView;
        [self addSubview:loadingIndicatorView];
        [loadingIndicatorView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.center.equalTo(self);
        }];
    }
}

- (void)setLoadingIndicatorHidden:(BOOL)hidden
{
    UIImageView *indicator = objc_getAssociatedObject(self, _cmd);
    if (hidden)
    {
        if (indicator)
        {
            [indicator removeFromSuperview];
            objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    else
    {
        if (!indicator)
        {
            indicator = [[UIImageView alloc] init];
            NSTimeInterval duration = 0;
            NSArray *images = [UIImage tx_gifImagesWithFile:BasePathForResource(@"loading", @"gif") totalDuration:&duration];
            indicator.animationImages = images;
            indicator.animationDuration = duration;
            indicator.animationRepeatCount = 0;
            [indicator startAnimating];
            objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)makeLoadingIndicatorViewAnimating
{
    UIImageView *imageView = self.loadingIndicatorView;
    if (imageView)
    {
        [imageView startAnimating];
        return;
    }
    for (UIView *subview in self.subviews)
    {
        [subview makeLoadingIndicatorViewAnimating];
    }
}

@end
