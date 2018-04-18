//
//  Network.h
//  base
//
//  Created by Demi on 10/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+BaseRACSupports.h"
#import "BaseHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject

@end

#define APINetwork Network.APISession
#define APIJSONNetwork Network.APIJSONSession

@interface Network (AFHTTPSessionManager)

+ (void)setAPIRelativeURL:(NSURL *)relativeURL;

@property (class, nonatomic, readonly, strong) BaseHTTPSessionManager *APISession;
@property (class, nonatomic, readonly, strong) BaseHTTPSessionManager *APIJSONSession;

@end

NS_ASSUME_NONNULL_END
