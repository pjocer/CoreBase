//
//  NSString+Validation.h
//  base
//
//  Created by Demi on 14/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidEmail;
- (BOOL)isValidPassword;
- (BOOL)isContainSpecialCharacters;

@end
