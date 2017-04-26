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
#import "util.h"

const NSNotificationName CookiesWillDeleteNotification = @"CookiesWillDeleteNotification";
const NSNotificationName CookiesDidDeleteNotification = @"CookiesDidDeleteNotification";

@implementation WebsiteDataStore

+ (void)setCookieName:(NSString *)name value:(NSString *)value
{
    NSDictionary *properties = @{NSHTTPCookieName: name,
                                 NSHTTPCookieValue: value,
                                 NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:7 * 24 * 3600],
                                 NSHTTPCookieDomain: @"*.azazie.com"};
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)removeAllCookies
{
    void(^start)(void) = ^{
        main_thread_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CookiesWillDeleteNotification object:nil];
        });
    };
    
    void(^completed)(void) = ^{
        
        main_thread_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidDeleteNotification object:nil];
        });
    };
    
    if ([WKWebsiteDataStore class])
    {
        start();
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:completed];
    }
    else
    {
        start();
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
        completed();
    }
}

@end
