//
//  WebsiteDataStore.h
//  base
//
//  Created by Demi on 25/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN const NSNotificationName CookiesDidDeleteNotification;

@interface WebsiteDataStore : NSObject

+ (void)removeAllCookies;

@end
