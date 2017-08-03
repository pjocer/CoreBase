//
//  UIScrollView+Loading.h
//  base
//
//  Created by Demi on 26/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Loading)

- (void)addRefreshHeaderWithBlock:(void(^)(void))block;
- (void)addRefreshFooterWithBlock:(void(^)(void))block;
- (void)beginHeaderRefreshing;
- (void)endHeaderRefreshing;
- (void)endFooterRefreshing:(BOOL)isNoMoreData;
- (void)removeRefreshHeader;
- (void)removeRefreshFooter;
@end
