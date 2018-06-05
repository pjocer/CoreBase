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
#import <ReactiveObjC/RACEXTKeyPathCoding.h>

@implementation Network

@end

@implementation Network (AFHTTPSessionManager)

+ (void)setAPIRelativeURL:(NSURL *)relativeURL {
    [self.APISession setValue:relativeURL forKeyPath:@keypath(self.APISession, baseURL)];
    [self.APIJSONSession setValue:relativeURL forKeyPath:@keypath(self.APIJSONSession, baseURL)];
}

+ (AFHTTPSessionManager *)APISession {
    static AFHTTPSessionManager *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[BaseHTTPSessionManager alloc] init];
    });
    return session;
}

+ (AFHTTPSessionManager *)APIJSONSession {
    static AFHTTPSessionManager *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[BaseHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:nil requestSerializer:[AFJSONRequestSerializer serializer]];
    });
    return session;
}

@end
