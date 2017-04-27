//
//  RouterRegistry.h
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RouterHandler <NSObject>

- (nullable id)request:(RouterRequest *)request;

@end

@interface RouterRegistry : NSObject

@property (nonatomic, copy, readonly, nullable) NSArray<id<RouterHandler>> *handlers;

- (void)register:(id<RouterHandler>)handler;

@end

NS_ASSUME_NONNULL_END
