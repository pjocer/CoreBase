//
//  RouterResponse.m
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RouterResponse.h"

@implementation RouterResponse

- (instancetype)initWithRequest:(RouterRequest *)request responseObject:(id)responseObject
{
    self = [super init];
    if (self)
    {
        _request = [request copy];
        _responseObject = responseObject;
    }
    return self;
}

@end
