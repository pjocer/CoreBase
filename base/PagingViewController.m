//
//  PagingViewController.m
//  base
//
//  Created by Demi on 07/03/2017.
//  Copyright © 2017 Taylor Tang. All rights reserved.
//

#import "PagingViewController.h"
#import "BasePagingView.h"
#import <TXFire/TXFire.h>
#import <Masonry/Masonry.h>

@interface PagingViewController ()

@end

@implementation PagingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    BasePagingView *view = [[BasePagingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    NSArray *pages = [@[@"1", @"2", @"3", @"4"] tx_map:^(NSString *text){
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.f
                                                green:(arc4random() % 256) / 255.f
                                                 blue:(arc4random() % 256) / 255.f
                                                alpha:1.f];
        return label;
    }];
    
    [view addPages:pages];
}

@end
