//
//  DrilldropViewController.m
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "DrilldropViewController.h"
#import "DrilldropMenuView.h"
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>

@interface DrilldropViewController ()

@end

@implementation DrilldropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DrilldropMenuItem *item1 = [[DrilldropMenuItem alloc] initWithTitle:@"Category"
                                                               options:@[@"All Bridesmaid Dresses",
                                                                         @"Maternity Bridesmaid",
                                                                         @"Modest Bridesmaid",
                                                                         @"Junior Bridesmaid Dresses",
                                                                         @"Separates"]
                                                                 image:[UIImage imageNamed:@"filter_category"]
                                                         selectedImage:nil];
    DrilldropMenuItem *item2 = [[DrilldropMenuItem alloc] initWithTitle:@"Filter"
                                                               options:nil
                                                                 image:[UIImage imageNamed:@"filter_normal"]
                                                         selectedImage:[UIImage imageNamed:@"filter_selected"]];
    DrilldropMenuItem *item3 = [[DrilldropMenuItem alloc] initWithTitle:@"Sort"
                                                                options:@[@"New arrivals",
                                                                          @"Most Popular",
                                                                          @"Prices Low to Hight",
                                                                          @"Prices High to Low"]
                                                                  image:[UIImage imageNamed:@"filter_category"]
                                                          selectedImage:nil];
    
    item1.usingOptionAsTitle = YES;
    
    DrilldropMenuView *view = [[DrilldropMenuView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.center.equalTo(self.view);
        maker.left.and.right.equalTo(self.view);
        maker.height.mas_equalTo(50.f);
    }];
    view.items = @[item1, item2, item3];
    
    [item2.didClickSignal subscribeNext:^(DrilldropMenuItem * _Nullable x) {
        Dlogvars(x.title);
        x.selected = !x.selected;
    }];
    
    @weakify(item1);
    [[RACObserve(item1, selectedOptionIndex) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(item1);
        Dlogvars(item1.options[[x integerValue]]);
    }];
}

@end
