//
//  AZLocationHandler.h
//  mobile
//
//  Created by abc on 2018/9/19.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const APPLocationDidChangeNotification;
FOUNDATION_EXTERN NSString *const LocationCookieName;

typedef NS_ENUM(NSUInteger, AZLocationAddress) {
    AZLocationAddress_America = 0,
    AZLocationAddress_Canada
};

@interface AZLocationHandler : NSObject <NSCopying, NSSecureCoding, CLLocationManagerDelegate>

@property (nonatomic, assign) AZLocationAddress location;

+ (AZLocationHandler *)defaultHaandler;

+ (void)setLocation:(AZLocationAddress)location;

+ (BOOL)isCanadaLocated;
+ (BOOL)isAmericaLocated;

+ (void)startDefaultLocat;

- (instancetype _Nullable)initWithLocation:(AZLocationAddress)location;

@end

NS_ASSUME_NONNULL_END
