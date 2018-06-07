//
//  AFHTTPSessionManager+BaseRACSupports.m
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "AFHTTPSessionManager+BaseRACSupports.h"
#import <TXFire/TXFire.h>
#import "UIApplication+Base.h"
#import <DebugBall/DebugManager.h>
#import "base.h"
#import <NSObject+YYModel.h>
#import "AccessToken.h"
#import "Profile.h"
#import "RACSignal+NSURLError.h"
#import <CoreUser/CoreUserManager.h>
#import <libkern/OSAtomic.h>

const HTTPMethod HTTPMethodGET = @"GET";
const HTTPMethod HTTPMethodPOST = @"POST";
const HTTPMethod HTTPMethodPUT = @"PUT";
const HTTPMethod HTTPMethodDELETE = @"DELETE";

InvalidTokenHandler defaultInvalidTokenHandler() {
    static dispatch_once_t onceToken;
    static InvalidTokenHandler handler = NULL;
    dispatch_once(&onceToken, ^{
        handler = ^(NSError * _Nonnull error) {
            main_thread_safe(^{
                [AccessToken setCurrentAccessToken:nil];
                [CoreUserManager loginFromViewController:[QMUIHelper visibleViewController]];
            });
        };
    });
    return handler;
}

@implementation AFHTTPSessionManager (BaseRACSupports)

/// AFNetworking 中的私有方法，copy出来使用
- (NSURLSessionDataTask *)base_dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSCAssert(self.baseURL, @"you must setAPIRelativeURL before.");
    NSURL *requestURL = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    if (![requestURL absoluteURL]) {
        requestURL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:self.baseURL];
    }
    if (![requestURL absoluteURL]) {
        if (failure) {
            NSError *urlError = [NSError errorWithDomain:AzazieErrorDomain code:AzazieErrorSingleError userInfo:@{AzazieErrorSingleErrorMessageKey:@"Sorry, lovely! Something went wrong, please try again."}];
            failure(nil, urlError);
        }
        return nil;
    }
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[requestURL absoluteString] parameters:parameters error:&serializationError];

#if DEBUG
    [DebugManager registerNetworkRequest:request type:APIDomainTypeDefault];
#endif
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}
- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters handleInvalidToken:(InvalidTokenHandler)action autoAlert:(BOOL)autoAlert {
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        @strongify(self);
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
        NetworkCachePolicy group_policy = [objc_getAssociatedObject(self, @selector(startGroupCachePolicy:)) unsignedIntegerValue];
        if (self.cachePolicy != group_policy) {
            self.cachePolicy = MAX(self.cachePolicy, group_policy);
        }
        switch (self.cachePolicy) {
            case AZURLRequestCacheDataThenRefresh: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                [subscriber sendNext:RACTuplePack(nil,cached_value)];
                [subscriber sendCompleted];
                [self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:nil compare:NO];
            }
                break;
            case AZURLRequestCacheDataThenRefreshSendNext: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                if (cached_value) {
                    [subscriber sendNext:RACTuplePack(nil,cached_value)];
                }
                [disposable addDisposable:[self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber compare:YES]];
            }
                break;
            case AZURLRequestCacheDataElseLoad: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                if (cached_value) {
                    [subscriber sendNext:RACTuplePack(nil,cached_value)];
                    [subscriber sendCompleted];
                } else {
                    [disposable addDisposable:[self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber compare:NO]];
                }
            }
                break;
            case AZURLRequestReloadIgnoringLocalCacheData: {
                self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                [disposable addDisposable:[self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber compare:NO]];
                [disposable addDisposable:[RACDisposable disposableWithBlock:^{
                    self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
                }]];
            }
                break;
            case AZURLRequestProtocolCachePolicy:
            default: {
                [disposable addDisposable:[self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber compare:NO]];
            }
                break;
        }
        [disposable addDisposable:[RACDisposable disposableWithBlock:^{
            self.cachePolicy = group_policy;
        }]];
        return disposable;
    }] handleInvalidToken:action autoAlert:autoAlert] ;
}

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters {
    return [self rac_method:method path:path parameters:parameters handleInvalidToken:defaultInvalidTokenHandler() autoAlert:YES];
}

- (RACDisposable *)rac_normalNetworkDisposable:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters subscriber:(id<RACSubscriber> _Nonnull)subscriber compare:(BOOL)compare {
    NSURLSessionDataTask *dataTask =
    [self base_dataTaskWithHTTPMethod:method
                            URLString:path
                           parameters:parameters
                       uploadProgress:nil
                     downloadProgress:nil
                              success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
                                  if (compare) {
                                      id cachedObject = [NetworkDAO getObjectById:self.cachedKey(path, parameters)];
                                      if (![cachedObject yy_modelIsEqual:responseObject]) {
                                          [subscriber sendNext:RACTuplePack(task.response, responseObject)];
                                          [subscriber sendCompleted];
                                      }
                                  } else {
                                      [subscriber sendNext:RACTuplePack(task.response, responseObject)];
                                      [subscriber sendCompleted];
                                  }
                                  Dlogvars(task.currentRequest.allHTTPHeaderFields);
                                  [[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] schedule:^{
                                      [NetworkDAO putObject:responseObject withId:self.cachedKey(path, parameters)];
                                  }];
                                  [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                              } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                  Dlogvars(dataTask.currentRequest.allHTTPHeaderFields);
                                  [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                  [subscriber sendError:error];
                              }];
    [dataTask resume];
    return [RACDisposable disposableWithBlock:^{
        [dataTask cancel];
    }];
}

- (NSString *)getCachedKeyBy:(NSString *)path parameters:(id)parameters {
    NSParameterAssert(path && path.length != 0);
    NSData *paramsData = parameters ? [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil] : nil;
    NSString *paramsString = paramsData ? [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding] : @"";
    return [path stringByAppendingString:[NSString stringWithFormat:@"?%@", paramsString]];
}

- (id)getCachedDataBy:(NSString *)path parameters:(id)parameters {
    return [NetworkDAO getObjectById:[self getCachedKeyBy:path parameters:parameters]];
}
- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(id)parameters {
    return [self rac_method:HTTPMethodGET path:path parameters:parameters];
}

- (RACSignal<RACTuple *> *)rac_POST:(NSString *)path parameters:(id)parameters {
    return [self rac_method:HTTPMethodPOST path:path parameters:parameters];
}

- (RACSignal<RACTuple *> *)rac_PUT:(NSString *)path parameters:(nullable id)parameters {
    return [self rac_method:HTTPMethodPUT path:path parameters:parameters];
}
- (RACSignal<RACTuple *> *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters {
    return [self rac_method:HTTPMethodDELETE path:path parameters:parameters];
}

@end

@implementation RACSignal (InvalidToken)
- (RACSignal *)handleInvalidToken:(InvalidTokenHandler)block autoAlert:(BOOL)autoAlert {
    return [self handleInvalidToken:block autoAlert:autoAlert blocked:NO];
}
- (RACSignal *)handleInvalidToken:(InvalidTokenHandler)block autoAlert:(BOOL)autoAlert blocked:(BOOL)blocked {
    static InvalidTokenHandler __innetHandler = NULL;
    static InvalidTokenHandler __innetBlock = NULL;
    static BOOL __innetAutoAlert = YES;
    static int32_t __invalidTokenSniffer = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __innetHandler = ^(NSError *error) {
            if (__invalidTokenSniffer == 0) {
                OSAtomicDecrement32(&__invalidTokenSniffer);
                if (__innetBlock) __innetBlock(error);
                OSAtomicIncrement32(&__invalidTokenSniffer);
            }
        };
    });
    static BOOL __innetBlocked = NO;
    static InvalidTokenHandler __blockedBlock = NULL;
    static BOOL __blockedAutoAlert = YES;
    if (blocked) {
        __innetBlocked = YES;
        __blockedBlock = block;
        __blockedAutoAlert = autoAlert;
    }
    __innetBlock = __innetBlocked ? __blockedBlock : block;
    __innetAutoAlert = __innetBlocked ? __blockedAutoAlert : autoAlert;
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        RACCompoundDisposable *__compoundDisposable = [RACCompoundDisposable compoundDisposable];
        RACDisposable *selfDisposable = [self subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
            if (__innetBlocked) __innetBlocked = NO;
        } error:^(NSError * _Nullable error) {
            if (error.errorGlobalCodeByServer.integerValue == 10301) {
                main_thread_safe(^{
                    [subscriber sendCompleted];
                    if (__innetAutoAlert) {
                        AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:error.errorMessageByServer preferConfirm:YES];
                        [alert addConfirmItemWithTitle:@"OK" action:^{
                            if (__innetHandler) __innetHandler(error);
                            if (__innetBlocked) __innetBlocked = NO;
                        }];
                        [alert show];
                    } else {
                        if (__innetHandler) __innetHandler(error);
                        if (__innetBlocked) __innetBlocked = NO;
                    }
                })
            } else {
                [subscriber sendError:error];
            }
        } completed:^{
            [subscriber sendCompleted];
        }];
        [__compoundDisposable addDisposable:[RACDisposable disposableWithBlock:^{
            [selfDisposable dispose];
        }]];
        [__compoundDisposable addDisposable:selfDisposable];
        return __compoundDisposable;
    }];
}
@end

@implementation AFHTTPSessionManager (CachePolicy)
- (CachePolicyHandler)cachePolicyHandler {
    return ^(NetworkCachePolicy policy) {
        self.cachePolicy = policy;
        return self;
    };
}
- (CachedKeyHandler)cachedKey {
    return ^(NSString *path, id parameters) {
        return [self getCachedKeyBy:path parameters:parameters];
    };
}
- (CachedValueHandler)cachedValue {
    return ^(NSString *path, id parameters) {
        return [self getCachedDataBy:path parameters:parameters];
    };
}
- (CachedValueDirectHandler)directCachedValue {
    return ^(NSString *key) {
        return [NetworkDAO getObjectById:key];
    };
}
- (NetworkCachePolicy)cachePolicy {
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    return value.unsignedIntegerValue;
}
- (void)setCachePolicy:(NetworkCachePolicy)cachePolicy {
    objc_setAssociatedObject(self, @selector(cachePolicy), @(cachePolicy), OBJC_ASSOCIATION_ASSIGN);
}
- (void)startGroupCachePolicy:(NetworkCachePolicy)policy {
    objc_setAssociatedObject(self, _cmd, @(policy), OBJC_ASSOCIATION_ASSIGN);
}
- (void)stopGroupCachePolicy{
    objc_setAssociatedObject(self, @selector(startGroupCachePolicy:), @(AZURLRequestProtocolCachePolicy), OBJC_ASSOCIATION_ASSIGN);
}
@end
