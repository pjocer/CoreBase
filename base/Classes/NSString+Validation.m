//
//  NSString+Validation.m
//  base
//
//  Created by Demi on 14/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "NSString+Validation.h"
#import <TXFire/TXFire.h>

@implementation NSString (Validation)

- (BOOL)isValidEmail
{
    return TXRegexMatch(@"^[\\w\\+\\._]+@\\w+\\.(\\w+\\.){0,3}\\w{2,4}$", self);
}

- (BOOL)isValidPassword
{
    return self.length >= 5;
}

- (BOOL)isContainSpecialCharacters
{
    return !TXRegexMatch(@"^[\\u0000-\uffff]*$", self);
}

@end
