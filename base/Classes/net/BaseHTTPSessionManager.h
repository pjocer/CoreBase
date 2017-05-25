//
//  BaseHTTPSessionManager.h
//  base
//
//  Created by Demi on 18/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseHTTPSessionManager : AFHTTPSessionManager

// @see initWithBaseURL:sessionConfiguration:
// 
- (instancetype)initWithBaseURL:(nullable NSURL *)url
           sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
              requestSerializer:(nullable AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
