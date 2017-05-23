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

@implementation BaseHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self)
    {
        [self.requestSerializer setValue:UserAgent.customUserAgent forHTTPHeaderField:@"User-Agent"];
        AFJSONResponseSerializer *jsonResponseSerializer = (AFJSONResponseSerializer *)self.responseSerializer;
        jsonResponseSerializer.removesKeysWithNullValues = YES;
        
        @weakify(self);
        [[[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccessTokenDidChangeNotification object:nil] map:^id _Nullable(NSNotification * _Nullable value) {
            return value.userInfo[AccessTokenChangeNewKey];
        }] startWith:[AccessToken currentAccessToken]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateHeaderForToken:x];
        }];
    }
    return self;
}

- (void)updateHeaderForToken:(AccessToken *)token
{
    @synchronized (self)
    {
        if (token)
        {
            [self.requestSerializer setValue:token.tokenString forHTTPHeaderField:@"Token"];
        }
        else
        {
            [self.requestSerializer setValue:nil forHTTPHeaderField:@"Token"];
        }
    }
}

@end
