//
//  Network.h
//  base
//
//  Created by Demi on 10/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+BaseRACSupports.h"
#import "BaseHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject

/// 启动长连接(获取Profile等)
+ (void)startService;

@end

@interface Network (UserAgent)

+ (NSString *)defaultUserAgent;
+ (NSString *)customUserAgent;

@end

@interface Network (AFHTTPSessionManager)

+ (void)setAPIRelativeURL:(NSURL *)relativeURL;

@property (class, nonatomic, readonly, strong) BaseHTTPSessionManager *APISession;

@end

NS_ASSUME_NONNULL_END
