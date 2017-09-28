//
//  RACSignal+NSURLError.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+NSURLError.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <TXFire/TXFire.h>
#import <AFNetworking.h>

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

@implementation RACSignal (NSURLError)

+ (void)__doNSURLErrorWithCode:(NSInteger)code forViewController:(__weak UIViewController *)viewController
{
    if (code == NSURLErrorCancelled)
    {
        return;
    }
    if (code == NSURLErrorDataNotAllowed)
    {
        notifyDataNotAllowed(viewController);
        return;
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
    hud.label.text = msg;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3.f];
}

+ (void)__doNSURLErrorWithCode:(NSInteger)code {
    
}

- (RACSignal *)catchURLErrorWithViewController:(__weak UIViewController *)viewController
{
    return [self catchNSURLErrorWithViewController:viewController];
}

- (RACSignal *)catchNSURLErrorWithViewController:(__weak UIViewController *)viewController
{
    @weakify(viewController);
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(viewController);
        
        Dlog(@"error domain: %@, code: %zd, localizedDescription: %@", error.domain, error.code, error.localizedDescription);
        
        if ([error.domain isEqualToString:NSURLErrorDomain])
        {
            [RACSignal __doNSURLErrorWithCode:error.code forViewController:viewController];
            return RACSignal.empty;
        }
        return [RACSignal error:error];
    }];
}
- (RACSignal *)catchNSURLError
{
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if ([error.domain isEqualToString:NSURLErrorDomain])
        {
            return [RACSignal empty];
        }
        else
        {
            return [RACSignal error:error];
        }
    }];
}
- (RACSignal *)catchNSURLErrorCancelled
{
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)
        {
            return [RACSignal return:nil];
        }
        else
        {
            return [RACSignal error:error];
        }
    }];
}

- (RACSignal *)catchNSURLErrorNoResponse {
    return [[self catchNSURLErrorCancelled] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain] && error.code == NSURLErrorBadServerResponse && [(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 404) {
            return [RACSignal return:nil];
        } else {
            return [RACSignal error:error];
        }
    }];
}

- (RACSignal *)doNSURLErrorWithViewController:(__weak UIViewController *)viewController
{
    @weakify(viewController);
    return [self doError:^(NSError * _Nonnull error) {
        @strongify(viewController);
        [RACSignal __doNSURLErrorWithCode:error.code forViewController:viewController];
    }];
}

- (RACSignal *)doNSURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        [RACSignal __doNSURLErrorWithCode:error.code];
    }];
}

@end
