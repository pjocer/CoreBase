//
//  NSString+Base.m
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "NSString+Base.h"

@implementation NSString (Base)

- (NSString *)firstWord
{
    return [self componentsSeparatedByString:@" "].firstObject ?: @"";
}

@end
