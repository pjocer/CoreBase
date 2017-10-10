//
//  RACSignal+NSURLError.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+NSURLError.h"
#import "AZAlert.h"
#import <TXFire/TXFire.h>
#import <AFNetworking.h>

static void notifyDataNotAllowed(void)
{
    AZAlert *alert = [AZAlert alertWithTitle:@"DataNotAllowed" detailText:nil preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"Settings" action:^{
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:NULL];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }];
    [alert addCancelItemWithTitle:@"Cancel" action:NULL];
    [alert show];
}

@implementation RACSignal (NSURLError)

+ (void)__doNSURLErrorWithCode:(NSInteger)code {
    if (code == NSURLErrorCancelled) {
        return;
    }
    if (code == NSURLErrorDataNotAllowed) {
        notifyDataNotAllowed();
        return;
    }
    NSString *msg = nil;
    if (code == NSURLErrorNotConnectedToInternet) {
        msg = @"The internet connection appears to be offline.";
    } else if (code == NSURLErrorTimedOut) {
        msg = @"The request timeout. Please try again.";
    } else {
        msg = @"Unable to connect to server. Please try again.";
    }
    
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:msg preferConfirm:NO];
    [alert addConfirmItemWithTitle:@"OK" action:NULL];
    [alert show];
}

- (RACSignal *)catchURLError {
    return [self catchNSURLError];
}

- (RACSignal *)catchNSURLError
{
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        Dlog(@"error domain: %@, code: %zd, localizedDescription: %@", error.domain, error.code, error.localizedDescription);
        if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [RACSignal __doNSURLErrorWithCode:error.code];
            return [RACSignal return:nil];
        }
        return [RACSignal error:error];
    }];
}

- (RACSignal *)catchNSURLErrorCancelled {
    return [[self catchNSURLError] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) {
            return [RACSignal return:nil];
        } else {
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

- (RACSignal *)doNSURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        [RACSignal __doNSURLErrorWithCode:error.code];
    }];
}

@end
