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
#import <libkern/OSAtomic.h>

const NSNotificationName CookiesWillDeleteNotification = @"CookiesWillDeleteNotification";
const NSNotificationName CookiesDidDeleteNotification = @"CookiesDidDeleteNotification";

@implementation WebsiteDataStore

+ (void)setCookieName:(NSString *)name value:(NSString *)value
{
    [self setCookieName:name value:value domain:@"*.azazie.com"];
}

+ (void)setCookieName:(NSString *)name value:(NSString *)value domain:(NSString *)domain {
    NSDictionary *properties = @{NSHTTPCookiePath: @"/",
                                 NSHTTPCookieName: name,
                                 NSHTTPCookieValue: value,
                                 NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:7 * 24 * 3600],
                                 NSHTTPCookieDomain: domain,
                                 };
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
    
    start();
    
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    [NSFileManager.defaultManager removeItemAtPath:[libraryPath stringByAppendingPathComponent:@"WebKit"] error:NULL];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
    for (NSHTTPCookie *cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    if ([WKWebsiteDataStore class])
    {
        __block volatile int32_t flag = 2;
        
        void(^completionHandler)(void) = ^{
            int32_t result = OSAtomicDecrement32(&flag);
            if (result == 0)
            {
                completed();
            }
        };
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                   modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                               completionHandler:completionHandler];
        [[WKWebsiteDataStore nonPersistentDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                         modifiedSince:[NSDate dateWithTimeIntervalSince1970:0]
                                                     completionHandler:completionHandler];
    }
    else
    {
        completed();
    }
}

@end
