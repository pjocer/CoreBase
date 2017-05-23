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
#import "ProfileAutoLoader.h"

@implementation Network

+ (void)startService
{
    [ProfileAutoLoader sharedLoader];
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
        AFHTTPRequestSerializer *requestSerializer = session.requestSerializer;
        [requestSerializer setAuthorizationHeaderFieldWithUsername:@"lebbay" password:@"passw0rd"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    });
    return session;
}

@end
