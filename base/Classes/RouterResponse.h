//
//  RouterResponse.h
//  router
//
//  Created by Demi on 21/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterRequest.h"

@interface RouterResponse : NSObject

@property (nonatomic, readonly, copy) RouterRequest *request;
@property (nonatomic, readonly, strong) id responseObject;

- (instancetype)initWithRequest:(RouterRequest *)request responseObject:(id)responseObject NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
