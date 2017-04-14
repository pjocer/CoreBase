//
//  RouterRegistry.h
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterResponse.h"
#import "RouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RouterHandler <NSObject>

- (BOOL)canRoute:(RouterRequest *)request;
- (nullable RouterResponse *)request:(RouterRequest *)request error:(NSError *_Nullable __autoreleasing* _Nullable)error;

@end

@interface RouterRegistry : NSObject

@property (nonatomic, copy, readonly, nullable) NSArray<id<RouterHandler>> *handlers;

- (void)register:(id<RouterHandler>)handler;

@end

NS_ASSUME_NONNULL_END
