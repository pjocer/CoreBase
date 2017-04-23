//
//  RACSignal+Util.m
//  base
//
//  Created by Demi on 23/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+Util.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <TXFire/TXFire.h>

static void notifyDataNotAllowed(UIViewController *vc)
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DataNotAllowed" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:NULL];
        }
        else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:settingAction];
    [alertController addAction:cancelAction];
    
    [vc presentViewController:alertController animated:YES completion:NULL];
}

@implementation RACSignal (Util)

- (RACSignal *)hudWithViewController:(__weak UIViewController *)viewController
{
    @weakify(viewController);
    return [[self initially:^{
        @strongify(viewController);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
        hud.graceTime = 0.5f;
        hud.removeFromSuperViewOnHide = YES;
    }] finally:^{
        @strongify(viewController);
        [MBProgressHUD hideHUDForView:viewController.view animated:YES];
    }];
}

- (RACSignal *)catchURLErrorWithViewController:(__weak UIViewController *)viewController
{
    @weakify(viewController);
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(viewController);
        if ([error.domain isEqualToString:NSURLErrorDomain])
        {
            Dlog(@"error domain: %@, code: %zd, localizedDescription: %@", error.domain, error.code, error.localizedDescription);
            
            NSInteger code = error.code;
            if (code == NSURLErrorCancelled)
            {
                return RACSignal.empty;
            }
            if (code == NSURLErrorDataNotAllowed)
            {
                notifyDataNotAllowed(viewController);
                return RACSignal.empty;
            }
            NSString *msg = nil;
            if (code == NSURLErrorNotConnectedToInternet)
            {
                msg = @"Oops! No internet connection.";
            }
            else if (code == NSURLErrorTimedOut)
            {
                msg = @"Oops! Request timeout.";
            }
            else
            {
                msg = @"Oops! Unable to connect to server.";
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
            hud.removeFromSuperViewOnHide = YES;
            hud.mode = MBProgressHUDModeText;
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:3.f];
            return RACSignal.empty;
        }
        return [RACSignal error:error];
    }];
}

@end
