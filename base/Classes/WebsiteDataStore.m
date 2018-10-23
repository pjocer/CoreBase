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
#import "AZLocationHandler.h"

const NSNotificationName CookiesWillDeleteNotification = @"CookiesWillDeleteNotification";
const NSNotificationName CookiesDidDeleteNotification = @"CookiesDidDeleteNotification";
const NSNotificationName CookiesDidChangedNotification = @"CookiesDidChangedNotification";

@implementation WebsiteDataStore

+ (NSHTTPCookie *)getCookie:(NSString *)name value:(NSString *)value domain:(NSString *)domain {
    if (!(name && value && domain)) {
        return nil;
    }
    NSDictionary *properties = @{NSHTTPCookiePath: @"/",
                                 NSHTTPCookieName: name,
                                 NSHTTPCookieValue: value,
                                 NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:7 * 24 * 3600],
                                 NSHTTPCookieDomain: domain,
                                 };
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    return cookie;
}

+ (NSArray<NSHTTPCookie *> *)getAllCustomCookies {
    NSMutableArray *cookies = [NSMutableArray array];
    [NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"login_token"] || [obj.name isEqualToString:LocationCookieName]) {
            [cookies addObject:obj];
        }
    }];
    return cookies;
}

+ (NSString *)getCookieString:(NSHTTPCookie *)cookie {
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;expiresDate=%@;path=%@",
                        cookie.name,
                        cookie.value,
                        cookie.domain,
                        cookie.expiresDate,
                        cookie.path ?: @"/"];
    
    return string;
}

+ (void)setCookieName:(NSString *)name value:(NSString *)value
{
    [self setCookieName:name value:value domain:@"*.azazie.com"];
}

+ (void)setCookieName:(NSString *)name value:(NSString *)value domain:(NSString *)domain {
    void(^deleteComplete)(void) = ^{
        NSHTTPCookie *cookie = [self getCookie:name value:value domain:domain];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        if (@available(iOS 11.0, *)) {
            main_thread_safe(^{
                [WKWebsiteDataStore.defaultDataStore.httpCookieStore setCookie:cookie completionHandler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidChangedNotification object:nil userInfo:nil];
                }];
            })
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidChangedNotification object:nil userInfo:nil];
        }
    };
    __block NSHTTPCookie *previous = nil;
    [NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            previous = obj;
            *stop = YES;
        }
    }];
    [NSHTTPCookieStorage.sharedHTTPCookieStorage deleteCookie:previous];
    if (@available(iOS 11.0, *)) {
        main_thread_safe(^{
            [WKWebsiteDataStore.defaultDataStore.httpCookieStore deleteCookie:previous completionHandler:^{
                deleteComplete();
            }];
        })
    } else {
        deleteComplete();
    }
}

+ (void)deleteCookieName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:CookiesWillDeleteNotification object:nil];
    __block NSHTTPCookie *cookie = nil;
    [NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:name]) {
            cookie = obj;
            *stop = YES;
        }
    }];
    [NSHTTPCookieStorage.sharedHTTPCookieStorage deleteCookie:cookie];
    if (@available(iOS 11.0, *)) {
        [WKWebsiteDataStore.defaultDataStore.httpCookieStore deleteCookie:cookie completionHandler:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidDeleteNotification object:nil];
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CookiesDidDeleteNotification object:nil];
    }
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
                                                   modifiedSince:[NSDate date]
                                               completionHandler:completionHandler];
        [[WKWebsiteDataStore nonPersistentDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                         modifiedSince:[NSDate date]
                                                     completionHandler:completionHandler];
    }
    else
    {
        completed();
    }
}

@end
