//
//  UIViewController+NetworkFailed.h
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NetworkView)

/// Add NetworkFailed component to self.view.
- (void)setNetworkFailedHidden:(BOOL)hidden;

/// Add NetworkLoading component to self.view.
- (void)setNetworkLoadingHidden:(BOOL)hidden;


@end
