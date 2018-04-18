//
//  AFHTTPSessionManager+BaseRACSupports.h
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HTTPMethod;

FOUNDATION_EXTERN const HTTPMethod HTTPMethodGET;
FOUNDATION_EXTERN const HTTPMethod HTTPMethodPOST;
FOUNDATION_EXTERN const HTTPMethod HTTPMethodPUT;
FOUNDATION_EXTERN const HTTPMethod HTTPMethodDELETE;

typedef NS_ENUM(NSUInteger, NetworkCachePolicy){
    AZURLRequestProtocolCachePolicy,            //按照协议获取缓存【默认】
    AZURLRequestCacheDataThenRefresh,           //获取缓存数据并立即sendNext:然后刷新缓存
    AZURLRequestCacheDataThenRefreshSendNext,   //获取缓存数据并立即sendNext:然后刷新缓存并再次sendNext:
    AZURLRequestCacheDataElseLoad,              //获取缓存数据，若无则刷新缓存，最后sendNext
    AZURLRequestReloadIgnoringLocalCacheData,   //忽略缓存，获取最新数据
};

@interface AFHTTPSessionManager (BaseRACSupports)

/**
 RACSignal的value为RACTuple(NSHTTPURLResponse<nullable>, id responseObject<nullable>)
 信号的sendNext, sendCompleted, sendError动作都在-completionQueue中发送.
 */

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(nullable id)parameters;

- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_POST:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_PUT:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters;

@end

typedef AFHTTPSessionManager *_Nullable(^CachePolicyHandler)(NetworkCachePolicy);
@class YTKKeyValueStore;
@interface AFHTTPSessionManager (CachePolicy)
@property (nonatomic, readonly) CachePolicyHandler cachePolicyHandler;
@property (nonatomic, assign) NetworkCachePolicy cachePolicy;
@property (nonatomic, strong, readonly) YTKKeyValueStore *DAOStore;
- (void)startGroupCachePolicy:(NetworkCachePolicy)policy;
- (void)stopGroupCachedPolicy;
@end

NS_ASSUME_NONNULL_END
