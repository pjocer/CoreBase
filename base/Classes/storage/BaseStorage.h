//
//  BaseStorage.h
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseStorage : NSObject

/// must be override
+ (NSString *)storageDirectory;

+ (nullable NSData *)readForKey:(NSString *)key;
+ (nullable NSDate *)modificationDateForKey:(NSString *)key;
+ (BOOL)write:(nullable NSData *)data toKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
