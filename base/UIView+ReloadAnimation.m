//
//  UIView+ReloadAnimation.m
//  mobile
//
//  Created by Jocer on 2017/8/4.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "UIView+ReloadAnimation.h"
#import <objc/runtime.h>

@implementation UITableView (ReloadAnimation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL = @selector(reloadData);
        SEL swizzledSEL = @selector(reloadDataWithAnimation);
        
        Method originMethod = class_getInstanceMethod(self, originSEL);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSEL);
        
        BOOL success = class_addMethod(self, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(self, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)reloadDataWithAnimation {
    [self reloadDataWithAnimation];
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setDuration:0.3];
    [[self layer] addAnimation:animation forKey:@"kUITableViewReloadDataAnimationKey"];
}

@end

@implementation UICollectionView (ReloadAnimation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL = @selector(reloadData);
        SEL swizzledSEL = @selector(reloadDataWithAnimation);
        
        Method originMethod = class_getInstanceMethod(self, originSEL);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSEL);
        
        BOOL success = class_addMethod(self, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(self, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)reloadDataWithAnimation {
    [self reloadDataWithAnimation];
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setDuration:0.3];
    [[self layer] addAnimation:animation forKey:@"kUICollectionViewReloadDataAnimationKey"];
}

@end
