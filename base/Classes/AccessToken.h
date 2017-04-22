//
//  AccessToken.h
//  CoreUser
//
//  Created by Demi on 12/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const AccessTokenDidChangeNotification;
FOUNDATION_EXTERN NSString *const AccessTokenDidChangeUserIDKey; // a boolean indicates whether user has been changed.
FOUNDATION_EXTERN NSString *const AccessTokenChangeOldKey;
FOUNDATION_EXTERN NSString *const AccessTokenChangeNewKey;

@interface AccessToken : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, readonly, copy) NSString *tokenString;
@property (nonatomic, readonly, copy) NSString *userID;
@property (nonatomic, readonly, copy) NSDate *expirationDate;
@property (nonatomic, readonly, copy) NSDate *refreshDate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithTokenString:(NSString *)tokenString
                             userID:(NSString *)userID
                     expirationDate:(NSDate *)expirationDate
                        refreshDate:(NSDate *)refreshDate NS_DESIGNATED_INITIALIZER;

/// thread safe
+ (nullable AccessToken *)currentAccessToken;
/// thread safe, also clear profile.
+ (void)setCurrentAccessToken:(nullable AccessToken *)token;

@end

NS_ASSUME_NONNULL_END
