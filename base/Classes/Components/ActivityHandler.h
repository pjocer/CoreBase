//
//  ActivityHandler.h
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const CyberMondayCountDownEndTime;
FOUNDATION_EXPORT NSString *const PreSaleCountDownEndTime;
FOUNDATION_EXPORT NSString *const CyberMondayActivityCode;

FOUNDATION_EXPORT NSString *const CyberMondayCountDownViewDisplayNotification;
FOUNDATION_EXPORT NSString *const CyberMondayPreSaleViewDisplayNotification;

@interface ActivityHandler : NSObject
@property (nonatomic, readonly, assign, getter=isCyberMondayViewAvaliable) BOOL cyberMondayViewAvaliable;
@property (nonatomic, readonly, assign, getter=isPreSaleViewAvaliable) BOOL preSaleViewAvaliable;
@property (nonatomic, readonly, assign, getter=isCyberMondayCouponCodeAvaliable) BOOL cyberMondayCouponCodeAvaliable;
@property (nonatomic, readonly, strong) NSDateFormatter *fmt;
@property (nonatomic, assign) BOOL hasClosedPreSaleView;

+ (instancetype)sharedHandler;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
