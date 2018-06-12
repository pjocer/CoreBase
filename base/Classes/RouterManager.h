//
//  RouterManager.h
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterRegistry.h"
#import "RouterRequest.h"
#import "BaseRouterHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface RouterManager : NSObject

+ (RouterManager *)sharedManager;

@property (nonatomic, readonly, strong) RouterRegistry *routerRegistry;

- (nullable id)request:(RouterRequest *)request;

@end

@interface RouterManager (Handler)
+ (BaseRouterHandler *)sharedBaseHandler;
@end

NS_ASSUME_NONNULL_END
