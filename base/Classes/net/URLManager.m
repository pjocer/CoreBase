//
//  URLManager.m
//  base
//
//  Created by Demi on 05/06/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "URLManager.h"
#import <TXFire/TXFire.h>

@implementation URLManager

static NSURL *baseURL = nil;

+ (void)setBaseURL:(NSURL *)URL
{
    baseURL = [URL copy];
}

+ (NSURL *)URLWithString:(NSString *)string
{
    return [NSURL URLWithString:string relativeToURL:baseURL];
}

+ (NSURL *)URLWithEncodingString:(NSString *)string
{
    NSString *encodedStr = [string tx_stringByEncodingURL];
    if (encodedStr)
    {
        return [self URLWithString:encodedStr];
    }
    return nil;
}

@end
