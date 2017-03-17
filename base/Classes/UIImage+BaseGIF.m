//
//  UIImage+BaseGIF.m
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIImage+BaseGIF.h"
#import <ImageIO/ImageIO.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <TXFire/TXFire.h>
#import "util.h"

static inline CGImageSourceRef CreateImageSourceWithFile(NSString *path)
{
    CFDataRef data = (__bridge CFDataRef)[NSData dataWithContentsOfFile:path];
    if (data == NULL)
    {
        return NULL;
    }
    
    return CGImageSourceCreateWithData(data, nil);
}

static inline CFArrayRef CreateImagesWithSourceAndCount(CGImageSourceRef const source, size_t const count)
{
    CFMutableArrayRef results = CFArrayCreateMutable(kCFAllocatorDefault, count, &kCFTypeArrayCallBacks);
    
    for (size_t i = 0; i < count; i++)
    {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, nil);
        CFArrayAppendValue(results, image);
        CGImageRelease(image);
    }
    
    return results;
}

static inline float ImageSourceGetTotalDuration(CGImageSourceRef const source, size_t const count)
{
    float duration = 0.f;
    
    for (int i = 0; i < count; i++)
    {
        CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        if (!properties)
        {
            continue;
        }
        
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties)
        {
            NSNumber *number =  (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0)
            {
                number =  (__bridge id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0)
            {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                duration += number.floatValue;
            }
        }
        CFRelease(properties);
    }
    
    return duration;
}

@implementation UIImage (BaseGIF)

+ (UIImage *)GIFAnimatedImageWithContentsOfFile:(NSString *)path
{
    CGImageSourceRef source = CreateImageSourceWithFile(path);
    if (!source)
    {
        return nil;
    }
    
    @onExit {
        CFRelease(source);
    };
    
    size_t count = CGImageSourceGetCount(source);
    if (count == 0) return nil;
    
    float duration = ImageSourceGetTotalDuration(source, count);
    NSArray *images = (__bridge_transfer NSArray *)CreateImagesWithSourceAndCount(source, count);
    
    return [self animatedImageWithImages:[images tx_map:^id _Nonnull(id  _Nonnull object) {
        return [UIImage imageWithCGImage:(CGImageRef)object scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    }] duration:duration];
}

+ (UIImage *)loadingGIF
{
    return [self GIFAnimatedImageWithContentsOfFile:BasePathForResource(@"loading", @"gif")];
}

@end
