//
//  NSError+Networking.h
//  base
//
//  Created by Demi on 18/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Networking)

@property (nonatomic, readonly, assign, getter=isRequestSerializationError) BOOL requestSerializationError;
@property (nonatomic, readonly, assign, getter=isResponseSerializationError) BOOL responseSerializationError;

@property (nonatomic, readonly, strong, nullable) NSData *responseData;
@property (nonatomic, readonly, strong, nullable) NSDictionary *responseObject;

@property (nonatomic, readonly, strong, nullable) NSHTTPURLResponse *HTTPResponse;

@property (nonatomic, readonly, strong, nullable) NSString *errorMessageByServer;
@property (nonatomic, readonly, strong, nullable) NSNumber *errorCodeByServer;

@end

NS_ASSUME_NONNULL_END
