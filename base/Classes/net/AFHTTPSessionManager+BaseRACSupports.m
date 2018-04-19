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

const HTTPMethod HTTPMethodGET = @"GET";
const HTTPMethod HTTPMethodPOST = @"POST";
const HTTPMethod HTTPMethodPUT = @"PUT";
const HTTPMethod HTTPMethodDELETE = @"DELETE";

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

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        @strongify(self);
        RACDisposable *disposable = nil;
        NetworkCachePolicy group_policy = [objc_getAssociatedObject(self, @selector(startGroupCachePolicy:)) unsignedIntegerValue];
        if (self.cachePolicy != group_policy) {
            self.cachePolicy = MAX(self.cachePolicy, group_policy);
        }
        switch (self.cachePolicy) {
            case AZURLRequestCacheDataThenRefresh: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                [subscriber sendNext:RACTuplePack(nil,cached_value)];
                [subscriber sendCompleted];
                [self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:nil];
            }
                break;
            case AZURLRequestCacheDataThenRefreshSendNext: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                if (cached_value) {
                    [subscriber sendNext:RACTuplePack(nil,cached_value)];
                }
                disposable = [self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber];
            }
                break;
            case AZURLRequestCacheDataElseLoad: {
                id cached_value = [self getCachedDataBy:path parameters:parameters];
                if (cached_value) {
                    [subscriber sendNext:RACTuplePack(nil,cached_value)];
                    [subscriber sendCompleted];
                } else {
                    disposable = [self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber];
                }
            }
                break;
            case AZURLRequestReloadIgnoringLocalCacheData: {
                RACCompoundDisposable *compoundDisposable = [RACCompoundDisposable compoundDisposable];
                self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                [compoundDisposable addDisposable:[self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber]];
                [compoundDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                    self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
                }]];
                disposable = compoundDisposable;
            }
                break;
            case AZURLRequestProtocolCachePolicy:
            default: {
                disposable = [self rac_normalNetworkDisposable:method path:path parameters:parameters subscriber:subscriber];
            }
                break;
        }
        self.cachePolicy = group_policy;
        return disposable;
    }];
}



- (RACDisposable *)rac_normalNetworkDisposable:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters subscriber:(id<RACSubscriber> _Nonnull)subscriber {
    NSURLSessionDataTask *dataTask =
    [self base_dataTaskWithHTTPMethod:method
                            URLString:path
                           parameters:parameters
                       uploadProgress:nil
                     downloadProgress:nil
                              success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
                                  [subscriber sendNext:RACTuplePack(task.response, responseObject)];
                                  [subscriber sendCompleted];
                                  Dlogvars(task.currentRequest.allHTTPHeaderFields);
                                  [[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] schedule:^{
                                    [NetworkDAO putObject:responseObject withId:[self getCachedKeyBy:path parameters:parameters]];
                                  }];
                                  [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                              } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                  [subscriber sendError:error];
                                  Dlogvars(dataTask.currentRequest.allHTTPHeaderFields);
                                  [[UIApplication sharedApplication] hideNetworkActivityIndicator];
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

- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(id)parameters
{
    return [self rac_method:HTTPMethodGET path:path parameters:parameters];
}

- (RACSignal<RACTuple *> *)rac_POST:(NSString *)path parameters:(id)parameters
{
    return [self rac_method:HTTPMethodPOST path:path parameters:parameters];
}

- (RACSignal<RACTuple *> *)rac_PUT:(NSString *)path parameters:(nullable id)parameters
{
    return [self rac_method:HTTPMethodPUT path:path parameters:parameters];
}
- (RACSignal<RACTuple *> *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters
{
    return [self rac_method:HTTPMethodDELETE path:path parameters:parameters];
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
