//
//  AppDelegate.m
//  boot
//
//  Created by Demi on 07/03/2017.
//  Copyright © 2017 Taylor Tang. All rights reserved.
//

#import "AppDelegate.h"
#import "PagingViewController.h"
#import "GIFViewController.h"
#import "Network.h"
#import <TXFire/TXFire.h>
#import "base.h"
#import "LoadingIndicatorTableViewController.h"
#import "DrilldropViewController.h"
#import "CNBViewController.h"
#import "UINavigationController+Base.h"
#import "NetworkLoadingViewController.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    PagingViewController *vc = [[PagingViewController alloc] initWithNibName:nil bundle:nil];
//    GIFViewController *vc = [[GIFViewController alloc] initWithNibName:nil bundle:nil];
//    LoadingIndicatorTableViewController *vc = [[LoadingIndicatorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    UIViewController *vc = [[DrilldropViewController alloc] initWithNibName:nil bundle:nil];
//    UIViewController *vc = [[CNBViewController alloc] initWithNibName:nil bundle:nil];
//    UIViewController *vc = [[NetworkLoadingViewController alloc] initWithNibName:nil bundle:nil];
    UITableViewController *vc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refreshing" style:UIBarButtonItemStylePlain target:nil action:nil];
    @weakify(vc);
    vc.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [vc.tableView beginHeaderRefreshing];
        return RACSignal.empty;
    }];
    [vc.tableView addRefreshHeaderWithBlock:^{
        static NSInteger take = 3;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(vc);
            take -= 1;
            [vc.tableView endHeaderRefreshing];
            if (take == 0)
            {
                [vc.tableView removeRefreshHeader];
            }
        });
    }];
    vc.navigationItem.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [nav makeAlwaysInteractivePopGestureRecognizer];
    
    [self.window makeKeyAndVisible];
    
    [Network setAPIRelativeURL:[NSURL URLWithString:@"https://api.azazie.com/1.0"]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
