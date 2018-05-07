//
//  RouterRequest.m
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RouterRequest.h"

@interface RouterRequest ()

@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) id<NSCopying> parameters;

@end

@implementation RouterRequest

- (instancetype)initWithURL:(NSURL *)URL parameters:(id)parameters {
    self = [super init];
    if (self) {
        _URL = [URL copy];
        _parameters = [parameters copy];
    }
    return self;
}
- (instancetype)initWithURL:(NSURL *)URL data:(id)data {
    self = [super init];
    if (self) {
        _URL = [URL copy];
        _data = data;
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[RouterRequest alloc] initWithURL:self.URL parameters:self.parameters];
}

@end
