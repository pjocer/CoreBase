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

@interface AFHTTPSessionManager (BaseRACSupports)

/// RACTuple(NSHTTPURLResponse<nullable>, id responseObject<nullable>)
- (RACSignal<RACTuple *> *)rac_GET:(NSString *)path parameters:(nullable id)parameters;

@end

NS_ASSUME_NONNULL_END
