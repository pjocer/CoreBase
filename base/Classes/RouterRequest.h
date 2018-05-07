//
//  RouterRequest.h
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouterRequest : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly, nullable) id<NSCopying> parameters;
@property (nonatomic, copy, readonly, nullable) id data;

- (instancetype)initWithURL:(NSURL *)URL parameters:(nullable id<NSCopying>)parameters;
- (instancetype)initWithURL:(NSURL *)URL data:(nullable id)data;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
