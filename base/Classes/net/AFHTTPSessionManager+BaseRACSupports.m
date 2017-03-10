//
//  AFHTTPSessionManager+BaseRACSupports.m
//  base
//
//  Created by Demi on 09/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "AFHTTPSessionManager+BaseRACSupports.h"
#import <TXFire/TXFire.h>

@implementation AFHTTPSessionManager (BaseRACSupports)

- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(id)parameters
{
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber){
        NSURLSessionDataTask *dataTask = [self GET:path
                                        parameters:parameters
                                          progress:NULL
                                           success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
                                               [subscriber sendNext:RACTuplePack(task.response, responseObject)];
                                               [subscriber sendCompleted];
                                               Dlogvars(task.currentRequest.allHTTPHeaderFields);
                                           }
                                           failure:^(NSURLSessionDataTask *task, NSError *error){
                                               [subscriber sendError:error];
                                               Dlogvars(task.currentRequest.allHTTPHeaderFields);
                                           }];
        
        if (dataTask)
        {
            return [RACDisposable disposableWithBlock:^{
                [dataTask cancel];
            }];
        }
        else
        {
            return (RACDisposable *)nil;
        }
    }];
}

@end
