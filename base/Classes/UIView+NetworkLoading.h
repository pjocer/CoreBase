//
//  UIView+NetworkLoading.h
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NetworkLoading)

- (UIView *)addSubviewForNetworkLoading;
- (void)removeSubviewForNetworkLoading;

@end
