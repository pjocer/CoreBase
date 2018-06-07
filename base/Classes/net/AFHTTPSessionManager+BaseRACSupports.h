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

typedef void(^InvalidTokenHandler)(NSError *error);

@interface AFHTTPSessionManager (BaseRACSupports)

/**
 RACSignal的value为RACTuple(NSHTTPURLResponse<nullable>, id responseObject<nullable>)
 信号的sendNext, sendCompleted, sendError动作都在-completionQueue中发送.
 */

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method
                                 path:(NSString *)path
                           parameters:(nullable id)parameters;

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method
                                 path:(NSString *)path
                           parameters:(nullable id)parameters
                   handleInvalidToken:(InvalidTokenHandler)action
                            autoAlert:(BOOL)autoAlert;

- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path
                        parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_POST:(NSString *)path
                         parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_PUT:(NSString *)path
                        parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_DELETE:(NSString *)path
                           parameters:(nullable id)parameters;
@end


@interface RACSignal (InvalidToken)

/**
 Only used for API request signal
 will override `block` and `autoAlert` by any new API request.

 @param block the handler will be called while invalid token error occurred
 @param autoAlert whether need auto alert
 @return current signal
 */
- (RACSignal *)handleInvalidToken:(InvalidTokenHandler)block
                        autoAlert:(BOOL)autoAlert;


/**
 Only used for API request signal
 will override `block` and `autoAlert` by any new API request.

 @param block the handler will be called while invalid token error occurred
 @param autoAlert whether need auto alert
 @param blocked whether need the handler of current API request to be blocked
 @return current signal
 */
- (RACSignal *)handleInvalidToken:(InvalidTokenHandler)block
                        autoAlert:(BOOL)autoAlert
                          blocked:(BOOL)blocked;

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

NS_ASSUME_NONNULL_END
