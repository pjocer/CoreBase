//
//  ProfileAutoLoader.h
//  base
//
//  Created by Demi on 22/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileAutoLoader : NSObject

+ (ProfileAutoLoader *)sharedLoader;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
