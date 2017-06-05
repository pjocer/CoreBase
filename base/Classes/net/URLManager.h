//
//  URLManager.h
//  base
//
//  Created by Demi on 05/06/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManager : NSObject

+ (void)setBaseURL:(NSURL *)URL;
+ (NSURL *)URLWithString:(NSString *)string;
+ (NSURL *)URLWithEncodingString:(NSString *)string;

@end
