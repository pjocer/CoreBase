//
//  CustomNavigationBarTableViewController.m
//  mobile
//
//  Created by Demi on 13/03/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "CustomNavigationBarTableViewController.h"
#import <TXFire/TXFire.h>

@interface CustomNavigationBarTableViewController ()

@property (nonatomic, assign) UITableViewStyle style;

@end

@implementation CustomNavigationBarTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _style = UITableViewStyleGrouped;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _style = UITableViewStyleGrouped;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
    _tableView = tableview;
    [self.view insertSubview:tableview atIndex:0];
    tableview.delegate = self;
    tableview.dataSource = self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    TXMethodNotImplemented();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TXMethodNotImplemented();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXMethodNotImplemented();
}

@end
