//
//  NSError+Networking.m
//  base
//
//  Created by Demi on 18/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "NSError+Networking.h"
#import <AFNetworking/AFNetworking.h>

@implementation NSError (Networking)

- (BOOL)isRequestSerializationError
{
    return [self.domain isEqualToString:AFURLRequestSerializationErrorDomain];
}

- (BOOL)isResponseSerializationError
{
    return [self.domain isEqualToString:AFURLResponseSerializationErrorDomain];
}

- (NSData *)responseData
{
    if (self.isRequestSerializationError)
    {
        return nil;
    }
    if (self.isResponseSerializationError)
    {
        return self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    }
    return nil;
}

- (NSDictionary *)responseObject
{
    NSData *responseData = [self responseData];
    if (!responseData)
    {
        return nil;
    }
    
    id object = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    if ([object isKindOfClass:NSDictionary.class])
    {
        return object;
    }
    return nil;
}

- (NSHTTPURLResponse *)HTTPResponse
{
    return self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
}

@end
