//
//  UserAgent.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAgent : NSObject

+ (NSString *)defaultUserAgent;
+ (NSString *)customUserAgent;

@end
