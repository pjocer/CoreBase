//
//  UIView+LoadingIndicator.h
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LoadingIndicator)

@property (nonatomic, readonly, strong, nullable) UIImageView *loadingIndicatorView;

/// add and start loading indicator at center.
- (void)startLoading;
/// stop and remove loading indicator.
- (void)stopLoading;

/// typically used on reuse for UITableViewCell, UICollectionViewCell, etc.
/// it seems UIImageView animating will be stopped in recycling. so need start animating again.
/// recursive subviews to get loading indicator, then start animating.
- (void)makeLoadingIndicatorViewAnimating;

@end

NS_ASSUME_NONNULL_END
