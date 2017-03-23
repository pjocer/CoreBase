//
//  UICollectionReusableView+LoadingIndicator.m
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UICollectionReusableView+LoadingIndicator.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <objc/runtime.h>
#import "UIView+LoadingIndicator.h"

static const void * kMakeLoadingIndicatorAnimatingOnReuse = &kMakeLoadingIndicatorAnimatingOnReuse;

@implementation UICollectionReusableView (LoadingIndicator)

- (BOOL)makeLoadingIndicatorAnimatingOnReuse
{
    return [objc_getAssociatedObject(self, kMakeLoadingIndicatorAnimatingOnReuse) boolValue];
}

- (void)setMakeLoadingIndicatorAnimatingOnReuse:(BOOL)makeLoadingIndicatorAnimatingOnReuse
{
    objc_setAssociatedObject(self, kMakeLoadingIndicatorAnimatingOnReuse, @(makeLoadingIndicatorAnimatingOnReuse), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (makeLoadingIndicatorAnimatingOnReuse)
    {
        RACDisposable *disposable = objc_getAssociatedObject(self, _cmd);
        if (disposable) return;
        
        disposable = [self.rac_prepareForReuseSignal subscribeNext:^(RACUnit * _Nullable x) {
            [self makeLoadingIndicatorViewAnimating];
        }].asScopedDisposable;
        objc_setAssociatedObject(self, _cmd, disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
