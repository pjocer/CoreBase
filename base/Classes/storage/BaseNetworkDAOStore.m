//
//  BaseNetworkDAOStore.m
//  AFNetworking
//
//  Created by Jocer on 2018/4/19.
//

#import "BaseNetworkDAOStore.h"

@implementation BaseNetworkDAOStore
+ (instancetype)sharedDAOStore {
    static dispatch_once_t onceToken;
    static BaseNetworkDAOStore *store = nil;
    dispatch_once(&onceToken, ^{
        store = [[BaseNetworkDAOStore alloc] initDBWithName:@"azazie.db"];
        [store createTableWithName:NETWORK_CACHE_TABLE];
    });
    return store;
}
- (id)getObjectById:(NSString *)objectId {
    if (!objectId || objectId.length <= 0)  return nil;
    return [self getObjectById:objectId fromTable:NETWORK_CACHE_TABLE];
}
- (void)putObject:(id)object withId:(NSString *)objectId {
    if (!object || !objectId || objectId.length <= 0)   return ;
    [self putObject:object withId:objectId intoTable:NETWORK_CACHE_TABLE];
}
@end
