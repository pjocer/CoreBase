//
//  BaseHTTPSessionManager.m
//  base
//
//  Created by Demi on 18/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseHTTPSessionManager.h"
#import "AccessToken.h"
#import "Network.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UserAgent.h"
#import "AppIdentifier.h"
#import "AZLocationHandler.h"

@implementation BaseHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration requestSerializer:(nullable AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self)
    {
        if (requestSerializer)
        {
            self.requestSerializer = requestSerializer;
        }
        
        [self.requestSerializer setHTTPMethodsEncodingParametersInURI:[NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil]];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"lebbay" password:@"passw0rd"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [self.requestSerializer setValue:UserAgent.customUserAgent forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:[AppIdentifier IDFA] forHTTPHeaderField:@"idfa"];
        [self.requestSerializer setValue:[AppIdentifier IDFV] forHTTPHeaderField:@"idfv"];
        
        //防止cookie被清除
        [AZLocationHandler defaultHaandler];
        
        //写入sample_source header
        for (NSHTTPCookie *cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies) {
            if ([cookie.name isEqualToString:@"sample_source"] && [cookie.domain isEqualToString:@".azazie.com"]) {
                [self.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value] forHTTPHeaderField:@"Cookie"];
                NSLog(@"%@=%@", cookie.name, cookie.value);
            }
        }
        
        AFJSONResponseSerializer *jsonResponseSerializer = (AFJSONResponseSerializer *)self.responseSerializer;
        jsonResponseSerializer.removesKeysWithNullValues = YES;
        
        @weakify(self);
        [[[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccessTokenDidChangeNotification object:nil] map:^id _Nullable(NSNotification * _Nullable value) {
            return value.userInfo[AccessTokenChangeNewKey];
        }] startWith:[AccessToken currentAccessToken]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateHeaderForToken:x];
        }];
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:APPLocationDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self);
            [self updateHeaderForLocation];
        }];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    return [self initWithBaseURL:url sessionConfiguration:configuration requestSerializer:nil];
}

- (void)updateHeaderForToken:(AccessToken *)token {
    @synchronized (self) {
        [self.requestSerializer setValue:token.tokenString forHTTPHeaderField:@"Token"];
    }
}

- (void)updateHeaderForLocation {
    @synchronized (self) {
        NSString *location = AZLocationHandler.isCanadaLocated ? @"CA" : @"US";
        [self.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@", @"sample_source", location] forHTTPHeaderField:@"Cookie"];
    }
}

@end
