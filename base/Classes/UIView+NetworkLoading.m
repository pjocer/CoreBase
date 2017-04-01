//
//  UIView+NetworkLoading.m
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIView+NetworkLoading.h"
#import <TXFire/TXFire.h>
#import <TXFire/UIImage+TXGIF.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <objc/runtime.h>
#import "util.h"

static const void * kNetworkLoadingView = &kNetworkLoadingView;

@implementation UIView (NetworkLoading)

- (UIView *)addSubviewForNetworkLoadingWithOffsetY:(CGFloat)offsetY
{
    UIView *networkLoadingView = objc_getAssociatedObject(self, kNetworkLoadingView);
    const NSInteger tag = 10;
    if (!networkLoadingView)
    {
        networkLoadingView = [[UIView alloc] init].tx_backgroundColor([UIColor tx_colorWithHex:0xf8f8f8]);
        objc_setAssociatedObject(self, kNetworkLoadingView, networkLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addSubview:networkLoadingView];
        [networkLoadingView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIImageView *gifImageView = [[UIImageView alloc] init];
        gifImageView.tag = tag;
        [networkLoadingView addSubview:gifImageView];
        
        NSTimeInterval duration = 0;
        CFArrayRef frames = [UIImage tx_gifFramesWithFile:BasePathForResource(@"refreshing", @"gif") totalDuration:&duration];
        gifImageView.animationImages = [(__bridge NSArray *)frames tx_map:^id _Nonnull(id  _Nonnull object) {
            CGImageRef cgImageRef = (__bridge CGImageRef)object;
            return [UIImage imageWithCGImage:cgImageRef scale:2 orientation:UIImageOrientationUp];
        }];
        gifImageView.animationDuration = duration;
        [gifImageView startAnimating];
    }
    
    [[networkLoadingView viewWithTag:tag] mas_remakeConstraints:^(MASConstraintMaker *maker){
        maker.centerX.equalTo(networkLoadingView);
        maker.centerY.equalTo(networkLoadingView).offset(offsetY);
    }];
    
    return networkLoadingView;
}

- (UIView *)addSubviewForNetworkLoading
{
    return [self addSubviewForNetworkLoadingWithOffsetY:0];
}

- (void)removeSubviewForNetworkLoading
{
    UIView *networkLoadingView = objc_getAssociatedObject(self, kNetworkLoadingView);
    if (networkLoadingView)
    {
        [networkLoadingView removeFromSuperview];
        objc_setAssociatedObject(self, kNetworkLoadingView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
