//
//  UIView+NetworkFailed.m
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIView+NetworkFailed.h"
#import <TXFire/TXFire.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import "NetworkFailedView.h"

static const void *kNetworkFailedComponent = &kNetworkFailedComponent;

@implementation UIView (NetworkFailed)

- (UIView *)addSubviewForNetworkFailedWithOffsetY:(CGFloat)offsetY
{
    UIView *view = objc_getAssociatedObject(self, kNetworkFailedComponent);
    const NSInteger tag = 10;
    if (!view)
    {
        view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        objc_setAssociatedObject(self, kNetworkFailedComponent, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.backgroundColor = [UIColor tx_colorWithHex:0xf8f8f8];
        
        NetworkFailedView *nfView = [[NetworkFailedView alloc] init];
        nfView.tag = tag;
        [view addSubview:nfView];
    }
    [[view viewWithTag:tag] mas_remakeConstraints:^(MASConstraintMaker *maker){
        maker.centerX.equalTo(view);
        maker.centerY.equalTo(view).offset(offsetY);
    }];
    
    return view;
}

- (UIView *)addSubviewForNetworkFailed {
    return [self addSubviewForNetworkFailedWithOffsetY:0];
}

- (void)removeSubviewForNetworkFailed
{
    UIView *view = objc_getAssociatedObject(self, kNetworkFailedComponent);
    if (view)
    {
        objc_setAssociatedObject(self, kNetworkFailedComponent, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [view removeFromSuperview];
    }
}

@end
