//
//  BaseNavigationController.m
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationController+Base.h"
#import "CustomNavigationBarViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeAlwaysInteractivePopGestureRecognizer];
}

- (void)setNeedBacklizeLeftBarButtonItemForViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[CustomNavigationBarViewController class]])
    {
        CustomNavigationBarViewController *cnbVC = (CustomNavigationBarViewController *)vc;
        if (!cnbVC.navigationBar.topItem.leftBarButtonItem)
        {
            [cnbVC backlizeLeftBarButtonItem];
        }
    }
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    if (viewControllers.count > 1)
    {
        for (NSUInteger i = 1; i < viewControllers.count; i++)
        {
            CustomNavigationBarViewController *vc = viewControllers[i];
            [self setNeedBacklizeLeftBarButtonItemForViewController:vc];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count == 1)
    {
        return;
    }
    [self setNeedBacklizeLeftBarButtonItemForViewController:viewController];
}

@end
