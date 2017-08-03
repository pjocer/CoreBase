//
//  RefreshActivityIndicatorViewFooter.m
//  mobile
//
//  Created by Demi on 01/04/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "RefreshActivityIndicatorViewFooter.h"
#import "NoMoreProductsView.h"
#import <Masonry.h>
#import <ReactiveObjC.h>

@interface RefreshActivityIndicatorViewFooter ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *noMoreProductsView;

@end

@implementation RefreshActivityIndicatorViewFooter

- (void)prepare
{
    [super prepare];
    
    self.mj_h = NoMoreProductsViewExpectedHeight + 30.f + 15.f;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (!self.activityIndicatorView)
    {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        RAC(self, activityIndicatorView.activityIndicatorViewStyle) = [RACObserve(self, activityIndicatorViewStyle) skip:1];
        [self addSubview:self.activityIndicatorView];
        self.activityIndicatorView.hidesWhenStopped = YES;
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    if (!self.noMoreProductsView)
    {
        self.noMoreProductsView = [[NoMoreProductsView alloc] init];
        [self addSubview:self.noMoreProductsView];
        self.noMoreProductsView.hidden = YES;
        [self.noMoreProductsView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsMake(30.f, 0, 15.f, 0));
        }];
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateNoMoreData)
    {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
        self.noMoreProductsView.hidden = NO;
    }
    else
    {
        self.activityIndicatorView.hidden = NO;
        self.noMoreProductsView.hidden = YES;
        
        if (state == MJRefreshStateIdle)
        {
            [self.activityIndicatorView stopAnimating];
        }
        else
        {
            [self.activityIndicatorView startAnimating];
        }
    }
}

@end
