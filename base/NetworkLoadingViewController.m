//
//  NetworkLoadingViewController.m
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "NetworkLoadingViewController.h"
#import "UIView+NetworkLoading.h"
#import <TXFire/TXFire.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface NetworkLoadingViewController ()

@end

@implementation NetworkLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [self.view addSubviewForNetworkLoading];
    @weakify(self);
    [view.tx_tapGestureRecognizer.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self.view removeSubviewForNetworkLoading];
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view removeSubviewForNetworkLoading];
//    });
}

@end
