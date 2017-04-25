//
//  WebsiteDataStore.m
//  base
//
//  Created by Demi on 25/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "WebsiteDataStore.h"
#import <WebKit/WebKit.h>
#import <TXFire/TXFire.h>

const NSNotificationName CookiesDidDeleteNotification = @"CookiesDidDeleteNotification";

@implementation WebsiteDataStore

+ (void)removeAllCookies
{
    void(^notify)(void) = ^{
        if (is_main_thread)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidDeleteNotification object:nil];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidDeleteNotification object:nil];
            });
        }
    };
    
    if ([WKWebsiteDataStore class])
    {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:notify];
    }
    else
    {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
        notify();
    }
}

@end
