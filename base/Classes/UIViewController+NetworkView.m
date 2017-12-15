//
//  UIViewController+NetworkFailed.m
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIViewController+NetworkView.h"
#import "UIView+NetworkFailed.h"
#import "UIView+NetworkLoading.h"
#import <TXFire/UIView+TXFire.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIViewController (NetworkView)

- (void)setNetworkFailedHidden:(BOOL)hidden {
    [self setNetworkFailedHidden:hidden tapHandler:nil];
}

- (void)setNetworkFailedHidden:(BOOL)hidden tapHandler:(NetworkViewTapHandler)handler {
    if (hidden) {
        [self.view removeSubviewForNetworkFailed];
    } else {
        [self.view addSubviewForNetworkFailedWithTapHandler:handler];
    }
}

- (void)setNetworkLoadingHidden:(BOOL)hidden {
    [self setNetworkLoadingHidden:hidden tapHandler:nil];
}

- (void)setNetworkLoadingHidden:(BOOL)hidden tapHandler:(NetworkViewTapHandler)handler {
    if (hidden) {
        [self.view removeSubviewForNetworkLoading];
    } else {
        [self.view addSubviewForNetworkLoadingWithTapHandler:handler];
    }
}

@end
