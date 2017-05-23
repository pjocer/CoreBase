//
//  AppIdentifier.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppIdentifier : NSObject

+ (NSString *)IDFA;
+ (NSString *)IDFV;

@end

NS_ASSUME_NONNULL_END
