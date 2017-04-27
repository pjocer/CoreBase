//
//  RouterManager.m
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RouterManager.h"

@implementation RouterManager

+ (RouterManager *)sharedManager
{
    static RouterManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RouterManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _routerRegistry = [[RouterRegistry alloc] init];
    }
    return self;
}

- (id)request:(RouterRequest *)request
{
    NSArray<id<RouterHandler>> *handlers = self.routerRegistry.handlers;
    for (id<RouterHandler> handler in handlers)
    {
        id resp = [handler request:request];
        if (resp)
        {
            return resp;
        }
    }
    return nil;
}

@end
