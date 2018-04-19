//
//  BaseDAOStore.h
//  AFNetworking
//
//  Created by Jocer on 2018/4/19.
//

#import <YTKKeyValueStore/YTKKeyValueStore.h>

@protocol BaseDAOStoreProtocol
@required
- (id)getObjectById:(NSString *)objectId;
- (void)putObject:(id)object withId:(NSString *)objectId;
@end

@interface BaseDAOStore : YTKKeyValueStore <BaseDAOStoreProtocol>
- (instancetype)init NS_DESIGNATED_INITIALIZER;
@end
