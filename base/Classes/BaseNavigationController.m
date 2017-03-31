//
//  BaseNavigationController.m
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationController+Base.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeAlwaysInteractivePopGestureRecognizer];
}

@end
