//
//  BaseStorage.m
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseStorage.h"
#import <TXFire/TXFire.h>
#import <CommonCrypto/CommonDigest.h>

static inline NSString *md5(NSString *string)
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@implementation BaseStorage

+ (NSString *)storageDirectory
{
    TXMethodNotImplemented();
}

+ (BOOL)ensureDirectoryExists
{
    NSString *dir = [self storageDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = isDir;
    if ([fm fileExistsAtPath:dir isDirectory:&isDir])
    {
        if (isDir)
        {
            return YES;
        }
        return NO;
    }
    return [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString *)filepathForKey:(NSString *)key
{
    NSString *path = md5(key);
    return [self.storageDirectory stringByAppendingPathComponent:path];
}

+ (NSData *)readForKey:(NSString *)key
{
    NSString *filepath = [self filepathForKey:key];
    return [NSData dataWithContentsOfFile:filepath];
}

+ (BOOL)write:(NSData *)data toKey:(NSString *)key
{
    NSString *filepath = [self filepathForKey:key];
    if (data)
    {
        if ([self ensureDirectoryExists])
        {
            return [data writeToFile:filepath atomically:YES];
        }
        return NO;
    }
    else
    {
        return [[NSFileManager defaultManager] removeItemAtPath:filepath error:NULL];
    }
}

+ (NSDate *)modificationDateForKey:(NSString *)key
{
    NSString *filepath = [self filepathForKey:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:filepath isDirectory:&isDirectory] && !isDirectory)
    {
        NSDictionary *attributes = [fm attributesOfItemAtPath:filepath error:NULL];
        if (attributes)
        {
            NSDate *date = attributes[NSFileModificationDate];
            if (!date)
            {
                return attributes[NSFileCreationDate];
            }
        }
    }
    return nil;
}

@end
