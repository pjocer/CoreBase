//
//  CustomNavigationBarTableViewController.h
//  mobile
//
//  Created by Demi on 13/03/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "CustomNavigationBarViewController.h"

@interface CustomNavigationBarTableViewController : CustomNavigationBarViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithStyle:(UITableViewStyle)style;

/// under custom navigationBar.
@property (nonatomic, readonly, strong) UITableView *tableView;

@end
