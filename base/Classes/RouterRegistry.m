//
//  RouterRegistry.m
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RouterRegistry.h"

@interface RouterRegistry ()

@property (nonatomic, strong) NSMutableArray<id<RouterHandler>> *internalHandlers;

@end

@implementation RouterRegistry

@dynamic handlers;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _internalHandlers = [NSMutableArray array];
    }
    return self;
}

- (void)register:(id<RouterHandler>)handler
{
    [_internalHandlers addObject:handler];
}

- (NSArray<id<RouterHandler>> *)handlers
{
    return _internalHandlers ? _internalHandlers.copy : nil;
}

@end
