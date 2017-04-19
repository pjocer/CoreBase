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

@interface AFHTTPSessionManager (BaseRACSupports)

/**
 RACSignal的value为RACTuple(NSHTTPURLResponse<nullable>, id responseObject<nullable>)
 信号的sendNext, sendCompleted, sendError动作都在-completionQueue中发送.
 */

- (RACSignal<RACTuple *> *)rac_method:(HTTPMethod)method path:(NSString *)path parameters:(id)parameters;

- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_POST:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_PUT:(NSString *)path parameters:(nullable id)parameters;
- (RACSignal<RACTuple *> *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters;

@end

NS_ASSUME_NONNULL_END
