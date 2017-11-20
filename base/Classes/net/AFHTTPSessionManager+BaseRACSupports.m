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
#import <base/base.h>

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

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[UIApplication sharedApplication] showNetworkActivityIndicator];
        
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
                                      [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                  } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                      [subscriber sendError:error];
                                      Dlogvars(dataTask.currentRequest.allHTTPHeaderFields);
                                      [[UIApplication sharedApplication] hideNetworkActivityIndicator];
                                  }];
        
        if (dataTask)
        {
            [dataTask resume];
            [RACDisposable disposableWithBlock:^{
                [dataTask cancel];
            }];
        }
        return nil;
    }];
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
