//
//  UIScrollView+Loading.h
//  base
//
//  Created by Demi on 26/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Loading)
- (BOOL)isHeaderRefreshing;
- (BOOL)isFooterRefreshing;
- (void)addRefreshHeaderWithBlock:(void(^)(void))block;
- (void)addRefreshFooterWithBlock:(void(^)(void))block;
- (void)beginHeaderRefreshing;
- (void)endHeaderRefreshing;
- (void)endHeaderRefreshingCompeletion:(dispatch_block_t)compeletion;
- (void)endFooterRefreshing:(BOOL)isNoMoreData;
- (void)removeRefreshHeader;
- (void)removeRefreshFooter;
@end
