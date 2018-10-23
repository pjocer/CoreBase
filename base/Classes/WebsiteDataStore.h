//
//  WebsiteDataStore.h
//  base
//
//  Created by Demi on 25/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN const NSNotificationName CookiesWillDeleteNotification;
FOUNDATION_EXTERN const NSNotificationName CookiesDidDeleteNotification;
FOUNDATION_EXTERN const NSNotificationName CookiesDidChangedNotification;

@interface WebsiteDataStore : NSObject

/// domain: *.azazie.com expires: 1 week
+ (void)setCookieName:(NSString *)name value:(NSString *)value;
+ (void)setCookieName:(NSString *)name value:(NSString *)value domain:(NSString *)domain;

+ (void)deleteCookieName:(NSString *)name;
+ (void)removeAllCookies;

+ (NSArray <NSHTTPCookie *>*)getAllCustomCookies;
+ (NSString *)getCookieString:(NSHTTPCookie *)cookie;

@end
