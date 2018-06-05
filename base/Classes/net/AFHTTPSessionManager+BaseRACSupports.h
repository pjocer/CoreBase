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
    AZURLRequestCacheDataThenRefreshSendNext,   //获取缓存数据并立即sendNext:然后刷新缓存并比较后选择是否再次sendNext:
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


/**
 Alternate cache policy

 @param NetworkCachePolicy cache policy
 @return self instance
 */
typedef AFHTTPSessionManager *(^CachePolicyHandler)(NetworkCachePolicy);

/**
 Get cached key by url path and related parameters

 @param path url path
 @param parameters url parameters
 @return cached key
 */
typedef NSString *_Nullable(^CachedKeyHandler)(NSString *path, id _Nullable parameters);

/**
 Get cached value by url path and related parameters

 @param path url path
 @param parameters url parameters
 @return cached value
 */
typedef id _Nullable(^CachedValueHandler)(NSString * path, id _Nullable parameters);

/**
 Get cached value by absolutelly key

 @param key
 @return value
 */
typedef id _Nullable(^CachedValueDirectHandler)(NSString *key);

@interface AFHTTPSessionManager (CachePolicy)
@property (nonatomic, readonly) CachePolicyHandler cachePolicyHandler;
@property (nonatomic, readonly) CachedKeyHandler cachedKey;
@property (nonatomic, readonly) CachedValueDirectHandler directCachedValue;
@property (nonatomic, readonly) CachedValueHandler cachedValue;
@property (nonatomic, assign) NetworkCachePolicy cachePolicy;
- (void)startGroupCachePolicy:(NetworkCachePolicy)policy;
- (void)stopGroupCachedPolicy;
@end


/**
 处理全局特殊Alert Action

 @param action action
 @param needAlert whether show
 @return self instance type
 */
typedef AFHTTPSessionManager *(^AlertActionHandler)(_Nullable dispatch_block_t action, BOOL needHiddenAlert);

@interface AFHTTPSessionManager (Alert)

/**
 处理invalid token，action为空默认呼出登录注册，needHiddenAlert为true则隐藏弹框提醒invalid token
 */
@property (nonatomic, readonly) AlertActionHandler invalidTokenActionHandler;
@property (nonatomic, copy) dispatch_block_t customInvalidTokenAction;
@property (nonatomic, assign) BOOL needHiddenInvalidTokenAlert;
@property (nonatomic, assign) BOOL isGroupInvalidTokenAction;
- (void)handleInvalidToken;

/**
 开启Group模式会禁掉Invalid Token自动弹框

 @param customInvalidTokenAction <#customInvalidTokenAction description#>
 */
- (void)startGroupInvalidTokenAction:(_Nullable dispatch_block_t)customInvalidTokenAction;
- (void)stopGroupInvalidTokenAction;
@end

NS_ASSUME_NONNULL_END
