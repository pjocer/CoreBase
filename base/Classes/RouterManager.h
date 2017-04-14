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
#import "RouterResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RouterManager : NSObject

+ (RouterManager *)sharedManager;

@property (nonatomic, readonly, strong) RouterRegistry *routerRegistry;

- (nullable RouterResponse *)request:(RouterRequest *)request error:(NSError *_Nullable __autoreleasing * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
