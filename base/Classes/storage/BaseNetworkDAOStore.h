//
//  BaseNetworkDAOStore.h
//  AFNetworking
//
//  Created by Jocer on 2018/4/19.
//

#import "BaseDAOStore.h"

#define NETWORK_CACHE_TABLE @"network_cache_table"
#define NetworkDAO [BaseNetworkDAOStore sharedDAOStore]

@interface BaseNetworkDAOStore : BaseDAOStore
+ (instancetype)sharedDAOStore;
- (void)clear;
@end
