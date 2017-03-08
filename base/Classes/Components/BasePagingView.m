//
//  BasePagingView.m
//  base
//
//  Created by Demi on 07/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BasePagingView.h"
#import <SMPageControl/SMPageControl.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@implementation BasePagingView

#pragma mark - initializer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.scrollsToTop = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        _scrollView = scrollView;
        [self addSubview:scrollView];
        
        SMPageControl *pageControl = [[SMPageControl alloc] initWithFrame:CGRectZero];
        pageControl.indicatorMargin = 6.f;
        pageControl.tapBehavior = SMPageControlTapBehaviorJump;
        _pageControl = pageControl;
        [self addSubview:pageControl];
        
        @weakify(self);
        [[[pageControl rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(SMPageControl *control){
            @strongify(self);
            CGRect rect = self.scrollView.bounds;
            rect.origin.x = control.currentPage * self.scrollView.bounds.size.width;
            [self.scrollView setContentOffset:rect.origin animated:YES];
        }];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [pageControl mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.and.right.equalTo(self);
            maker.bottom.equalTo(self).offset(-10.f);
        }];
    }
    return self;
}

#pragma mark - reaction

- (void)configurePage
{
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX <= 0)
    {
        self.pageControl.currentPage = 0;
    }
    CGFloat page = offsetX / width;
    self.pageControl.currentPage = (NSUInteger)round(page);
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self configurePage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self configurePage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self configurePage];
}

#pragma mark - add pages

- (void)removePages
{
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)addPages:(NSArray<UIView *> *)pages
{
    NSCAssert(pages.count > 0, @"The pages you provides must not be empty.");
    
    [self removePages];
    
    self.pageControl.numberOfPages = pages.count;
    self.pageControl.currentPage = 0;
    
    UIScrollView *scrollView = self.scrollView;
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.edges.equalTo(scrollView);
        maker.height.equalTo(scrollView);
    }];
    
    UIView *lastPage = nil;
    for (UIView *page in pages)
    {
        [scrollView addSubview:page];
        [page mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(lastPage ? lastPage.mas_right : scrollView);
            maker.top.and.height.and.width.equalTo(scrollView);
        }];
        lastPage = page;
    }
    [contentView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.right.equalTo(lastPage);
    }];
}

@end
