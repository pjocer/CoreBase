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

- (RouterResponse *)request:(RouterRequest *)request error:(NSError *__autoreleasing  _Nullable *)error
{
    return nil;
}

@end
