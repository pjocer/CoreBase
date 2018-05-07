//
//  RefreshActivityIndicatorViewFooter.h
//  mobile
//
//  Created by Demi on 01/04/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <UIKit/UIKit.h>

@interface RefreshActivityIndicatorViewFooter : MJRefreshAutoFooter

@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, assign) BOOL disableNoMoreProductView;

@end
