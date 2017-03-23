//
//  UIView+NetworkFailed.h
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NetworkFailed)

/// Filling sender with white background.
- (UIView *)addSubviewForNetworkFailed;
- (void)removeSubviewForNetworkFailed;

@end
