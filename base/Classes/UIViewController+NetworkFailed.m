//
//  UIViewController+NetworkFailed.m
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIViewController+NetworkFailed.h"
#import "UIView+NetworkFailed.h"

@implementation UIViewController (NetworkFailed)

- (void)setNetworkFailedHidden:(BOOL)hidden
{
    if (hidden)
    {
        [self.view addSubviewForNetworkFailed];
    }
    else
    {
        [self.view removeSubviewForNetworkFailed];
    }
}

@end
