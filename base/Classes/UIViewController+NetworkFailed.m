//
//  UIViewController+NetworkFailed.m
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIViewController+NetworkFailed.h"
#import "UIView+NetworkFailed.h"
#import "UIView+NetworkLoading.h"

@implementation UIViewController (NetworkFailed)

- (void)setNetworkFailedHidden:(BOOL)hidden {
    if (hidden) {
        [self.view removeSubviewForNetworkFailed];
    } else {
        [self.view addSubviewForNetworkFailed];
    }
}

- (void)setNetworkLoadingHidden:(BOOL)hidden {
    if (hidden) {
        [self.view removeSubviewForNetworkLoading];
    } else {
        [self.view addSubviewForNetworkLoading];
    }
}

@end
