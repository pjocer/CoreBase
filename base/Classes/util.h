//
//  util.h
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TXFire/TXFire.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * _Nullable BasePathForResource(NSString *_Nonnull name, NSString *_Nullable ext);
UIKIT_EXTERN UIImage *_Nullable BaseImageWithNamed(NSString *name);

#ifndef main_thread_safe
#define main_thread_safe(block) \
    if (is_main_thread) \
    { \
        block(); \
    } \
    else \
    { \
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#ifndef IS_AZAZIE
#define IS_AZAZIE \
[[NSBundle.mainBundle.bundleIdentifier componentsSeparatedByString:@"."][1] isEqualToString:@"azazie"]
#endif

#ifndef IS_LOVEPROM
#define IS_LOVEPROM \
[[NSBundle.mainBundle.bundleIdentifier componentsSeparatedByString:@"."][1] isEqualToString:@"loveprom"]
#endif

NS_ASSUME_NONNULL_END
