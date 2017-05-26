//
//  UIScrollView+Loading.m
//  base
//
//  Created by Demi on 26/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIScrollView+Loading.h"
#import <MJRefresh/MJRefresh.h>
#import <TXFire/TXFire.h>
#import <TXFire/UIImage+TXGIF.h>
#import "util.h"

static NSArray<UIImage *> *refreshingGif(NSTimeInterval *duration)
{
    NSString *file = BasePathForResource(@"refreshing_header", @"gif");
    CFArrayRef frames = [UIImage tx_gifFramesWithFile:file totalDuration:duration];
    if (!frames)
    {
        return NULL;
    }
    CFIndex count = CFArrayGetCount(frames);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (CFIndex idx = 0; idx < count; idx++)
    {
        CGImageRef frame = (CGImageRef)CFArrayGetValueAtIndex(frames, idx);
        [results addObject:[UIImage imageWithCGImage:frame scale:2.0 orientation:UIImageOrientationUp]];
    }
    return results;
}

@implementation UIScrollView (Loading)

- (void)addRefreshHeaderWithBlock:(void (^)(void))block
{
    MJRefreshGifHeader *refreshHeader = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    refreshHeader.mj_h = 80.f;
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    
    NSTimeInterval duration = 0;
    NSArray *images = refreshingGif(&duration);
    
    [refreshHeader setImages:images duration:duration forState:MJRefreshStateIdle];
    [refreshHeader setImages:images duration:duration forState:MJRefreshStatePulling];
    [refreshHeader setImages:images duration:duration forState:MJRefreshStateWillRefresh];
    [refreshHeader setImages:images duration:duration forState:MJRefreshStateRefreshing];
    
    self.mj_header = refreshHeader;
}

- (void)beginHeaderRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)endHeaderRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)removeRefreshHeader
{
    self.mj_header = nil;
}

@end
