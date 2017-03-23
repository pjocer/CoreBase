//
//  LoadingIndicatorTableViewController.m
//  base
//
//  Created by Demi on 23/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "LoadingIndicatorTableViewController.h"
#import <Masonry/Masonry.h>
#import "base.h"

@interface LoadingIndicatorTableViewController ()

@end

@implementation LoadingIndicatorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.tableView.backgroundColor = [UIColor blueColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
        cell.makeLoadingIndicatorAnimatingOnReuse = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImageWithDefaultPlaceholder];
    }
    return cell;
}

@end
