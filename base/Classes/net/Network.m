//
//  Network.m
//  base
//
//  Created by Demi on 10/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "Network.h"
#import <pthread/pthread.h>
#import <UIKit/UIKit.h>
#import <TXFire/TXFire.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AccessToken.h"

//static inline pthread_mutex_t shared_mutex(void)
//{
//    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
//    return mutex;
//}
//
@implementation Network

@end

@implementation Network (UserAgent)

+ (NSString *)retrieveUserAgentInWebview
{
    static NSString *userAgent = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    });
    return userAgent;
}

+ (NSString *)defaultUserAgent
{
    return [self retrieveUserAgentInWebview];
}

+ (NSString *)customUserAgent
{
    NSString *userAgent = [self retrieveUserAgentInWebview];
    return [NSString stringWithFormat:@"%@ Azazie/%@", userAgent, [UIApplication sharedApplication].tx_appVersion];
}

@end

@implementation Network (AFHTTPSessionManager)

static NSURL *APIRelativeURL = nil;

+ (void)setAPIRelativeURL:(NSURL *)relativeURL
{
    APIRelativeURL = [relativeURL copy];
}

+ (AFHTTPSessionManager *)APISession
{
    static AFHTTPSessionManager *session = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSCAssert(APIRelativeURL, @"you must setAPIRelativeURL before.");
        session = [[BaseHTTPSessionManager alloc] initWithBaseURL:APIRelativeURL];
    });
    return session;
}

@end
