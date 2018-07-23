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

- (UIView *)addSubviewForNetworkLoadingWithOffsetY:(CGFloat)offsetY {
    return [self addSubviewForNetworkLoadingWithOffsetY:offsetY tapHandler:nil];
}

- (UIView *)addSubviewForNetworkLoading {
    return [self addSubviewForNetworkLoadingWithOffsetY:0];
}

- (UIView *)addSubviewForNetworkLoadingWithTapHandler:(NetworkViewTapHandler)handler {
    return [self addSubviewForNetworkLoadingWithOffsetY:0 tapHandler:handler];
}

- (UIView *)addSubviewForNetworkLoadingWithTitle:(NSString *)title detailTexts:(NSArray *)texts {
    UIView *networkLoadingView = objc_getAssociatedObject(self, kNetworkLoadingView);
    static NSInteger title_tag = 1088;
    static NSInteger detail_tag = 1089;
    if (!networkLoadingView) {
        networkLoadingView = [[UIView alloc] init];
        objc_setAssociatedObject(self, kNetworkLoadingView, networkLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:networkLoadingView];
        [networkLoadingView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        
        UIView *contentView = [[UIView alloc] init];
        [networkLoadingView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(networkLoadingView);
        }];
        
        UIImageView *gifImageView = [[UIImageView alloc] init];
        [contentView addSubview:gifImageView];
        [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(contentView);
        }];
        NSTimeInterval duration = 0;
        CFArrayRef frames = [UIImage tx_gifFramesWithFile:BasePathForResource(IS_AZAZIE?@"refreshing":@"refreshing_loveprom", @"gif") totalDuration:&duration];
        gifImageView.animationImages = [(__bridge NSArray *)frames tx_map:^id _Nonnull(id  _Nonnull object) {
            CGImageRef cgImageRef = (__bridge CGImageRef)object;
            return [UIImage imageWithCGImage:cgImageRef scale:2 orientation:UIImageOrientationUp];
        }];
        gifImageView.animationDuration = duration;
        [gifImageView startAnimating];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:16];
        title.tag = title_tag;
        title.textColor = [UIColor tx_colorWithHex:0x333333];
        title.textAlignment = NSTextAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gifImageView.mas_bottom).offset(37);
            make.centerX.equalTo(gifImageView);
            make.width.lessThanOrEqualTo(contentView);
        }];
        
        UILabel *detail = [[UILabel alloc] init];
        detail.font = [UIFont systemFontOfSize:13];
        detail.tag = detail_tag;
        detail.textColor = [UIColor tx_colorWithHex:0x999999];
        detail.textAlignment = NSTextAlignmentCenter;
        detail.lineBreakMode = NSLineBreakByWordWrapping;
        detail.numberOfLines = 0;
        [contentView addSubview:detail];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(8);
            make.centerX.equalTo(gifImageView);
            make.width.lessThanOrEqualTo(contentView);
            make.bottom.equalTo(contentView);
        }];
    }
    [(UILabel *)[networkLoadingView viewWithTag:title_tag] setText:title];
    UILabel *detail = [networkLoadingView viewWithTag:detail_tag];
    @weakify(detail);
    [[[[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]] takeUntil:[networkLoadingView rac_signalForSelector:@selector(removeFromSuperview)]] map:^id _Nullable(NSDate * _Nullable value) {
        static NSInteger idx = -1;
        return @(++idx);
    }] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(detail);
        [UIView animateWithDuration:0.3 animations:^{
            detail.text = texts[x.integerValue];
        }];
    }];
    return networkLoadingView;
}

- (UIView *)addSubviewForNetworkLoadingWithOffsetY:(CGFloat)offsetY tapHandler:(NetworkViewTapHandler)handler {
    UIView *networkLoadingView = objc_getAssociatedObject(self, kNetworkLoadingView);
    const NSInteger tag = 10;
    if (!networkLoadingView)
    {
        networkLoadingView = [[UIView alloc] init].tx_backgroundColor([UIColor tx_colorWithHex:0xf8f8f8]);
        objc_setAssociatedObject(self, kNetworkLoadingView, networkLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(networkLoadingView);
        [networkLoadingView.tx_tapGestureRecognizer.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(networkLoadingView);
            if (handler) handler(networkLoadingView);
        }];
        
        [self addSubview:networkLoadingView];
        [networkLoadingView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIImageView *gifImageView = [[UIImageView alloc] init];
        gifImageView.tag = tag;
        [networkLoadingView addSubview:gifImageView];
        
        NSTimeInterval duration = 0;
        CFArrayRef frames = [UIImage tx_gifFramesWithFile:BasePathForResource(IS_AZAZIE?@"refreshing":@"refreshing_loveprom", @"gif") totalDuration:&duration];
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
