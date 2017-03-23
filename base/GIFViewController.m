//
//  GIFViewController.m
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "GIFViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface GIFViewController ()

@end

@implementation GIFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.center.equalTo(self.view);
    }];
}

@end
