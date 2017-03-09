//
//  BaseTmpNetworkStorage.m
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseTmpNetworkStorage.h"

@implementation BaseTmpNetworkStorage

+ (NSString *)storageDirectory
{
    return [NSTemporaryDirectory() stringByAppendingString:@"network_cache"];
}

@end
