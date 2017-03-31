//
//  UINavigationController+Base.m
//  base
//
//  Created by Demi on 30/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UINavigationController+Base.h"
#import "InteractivePopDelegateProxy.h"
#import <objc/runtime.h>

static const void * kInteractivePopDelegateProxy = &kInteractivePopDelegateProxy;

@implementation UINavigationController (Base)

- (void)makeAlwaysInteractivePopGestureRecognizer
{
    InteractivePopDelegateProxy *interactivePopDelegateProxy = objc_getAssociatedObject(self, kInteractivePopDelegateProxy);
    if (interactivePopDelegateProxy)
    {
        return;
    }
    interactivePopDelegateProxy = [[InteractivePopDelegateProxy alloc] init];
    interactivePopDelegateProxy.navigationController = self;
    interactivePopDelegateProxy.originalDelegate = self.interactivePopGestureRecognizer.delegate;
    self.interactivePopGestureRecognizer.delegate = interactivePopDelegateProxy;
    objc_setAssociatedObject(self, kInteractivePopDelegateProxy, interactivePopDelegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
