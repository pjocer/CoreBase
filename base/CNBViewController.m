//
//  CNBViewController.m
//  base
//
//  Created by Demi on 29/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "CNBViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface CNBViewController ()

@end

@implementation CNBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.navigationBar.topItem.title = [NSUUID UUID].UUIDString;
    
    [button mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.center.equalTo(self.view);
    }];
    
    @weakify(self);
    button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        CNBViewController *vc = [[CNBViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return RACSignal.empty;
    }];
}

@end
