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

@implementation BaseHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self)
    {
        [self.requestSerializer setValue:Network.customUserAgent forHTTPHeaderField:@"User-Agent"];
        AFJSONResponseSerializer *jsonResponseSerializer = (AFJSONResponseSerializer *)self.responseSerializer;
        jsonResponseSerializer.removesKeysWithNullValues = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccessTokenChanged:) name:AccessTokenDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onAccessTokenChanged:(NSNotification *)note
{
    @synchronized (self)
    {
        AccessToken *token = note.userInfo[AccessTokenChangeNewKey];
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
