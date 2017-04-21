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

@property (nonatomic, readonly, copy) NSString *user_id;
@property (nonatomic, readonly, copy, nullable) NSString *user_name;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, assign) NSInteger language_id;
@property (nonatomic, readonly, assign) NSInteger currency_id;
@property (nonatomic, readonly, copy) NSString *lang_code;
@property (nonatomic, readonly, assign) NSInteger shoppingCartGoodsTotal;

/// thread safe
+ (nullable Profile *)currentProfile;

+ (RACSignal<Profile *> *)loadProfile;

@end

NS_ASSUME_NONNULL_END
