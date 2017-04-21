//
//  Profile.h
//  base
//
//  Created by Demi on 21/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const ProfileDidChangeNotification;
FOUNDATION_EXTERN NSString *const ProfileChangeOldKey;
FOUNDATION_EXTERN NSString *const ProfileChangeNewKey;

@interface Profile : JSONModel

@property (nonatomic, readonly, copy) NSString *userID;
@property (nonatomic, readonly, copy, nullable) NSString *userName;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, assign) NSInteger languageID;
@property (nonatomic, readonly, assign) NSInteger currencyID;
@property (nonatomic, readonly, copy) NSString *langCode;
@property (nonatomic, readonly, assign) NSInteger shoppingCartGoodsTotal;

/// thread safe
+ (nullable Profile *)currentProfile;

+ (RACSignal<Profile *> *)loadProfile;

@end

NS_ASSUME_NONNULL_END
