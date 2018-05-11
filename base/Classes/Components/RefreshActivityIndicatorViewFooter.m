//
//  RefreshActivityIndicatorViewFooter.m
//  mobile
//
//  Created by Demi on 01/04/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "RefreshActivityIndicatorViewFooter.h"
#import "NoMoreProductsView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RefreshActivityIndicatorViewFooter ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *noMoreProductsView;

@end

@implementation RefreshActivityIndicatorViewFooter

- (void)prepare {
    [super prepare];
    
    self.disableNoMoreProductView = NO;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (!self.activityIndicatorView) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        RAC(self, activityIndicatorView.activityIndicatorViewStyle) = [RACObserve(self, activityIndicatorViewStyle) skip:1];
        [self addSubview:self.activityIndicatorView];
        self.activityIndicatorView.hidesWhenStopped = YES;
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    if (!self.noMoreProductsView && !self.disableNoMoreProductView) {
        self.noMoreProductsView = [[NoMoreProductsView alloc] init];
        [self addSubview:self.noMoreProductsView];
        self.noMoreProductsView.hidden = YES;
        [self.noMoreProductsView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsMake(30.f, 0, 15.f, 0));
        }];
    }
}
- (void)setDisableNoMoreProductView:(BOOL)disableNoMoreProductView {
    _disableNoMoreProductView = disableNoMoreProductView;
    self.mj_h = disableNoMoreProductView ? 45.f : NoMoreProductsViewExpectedHeight + 30.f + 15.f;
}
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    if (state == MJRefreshStateNoMoreData) {
        [self.activityIndicatorView stopAnimating];
        self.noMoreProductsView.hidden = _disableNoMoreProductView;
    } else {
        self.noMoreProductsView.hidden = YES;
        if (state == MJRefreshStateIdle) {
            [self.activityIndicatorView stopAnimating];
        } else {
            [self.activityIndicatorView startAnimating];
        }
    }
}

@end
