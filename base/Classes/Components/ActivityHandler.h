//
//  ActivityHandler.h
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopNotificationModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

// 黑色倒计时
FOUNDATION_EXPORT NSString *const ActivityCountDownEndTime;
FOUNDATION_EXPORT NSString *const ActivityCountDownStartTime;
// 预售倒计时
FOUNDATION_EXPORT NSString *const PreSaleCountDownEndTime;
FOUNDATION_EXPORT NSString *const PreSaleCountDownStartTime;
// Coupon倒计时
FOUNDATION_EXPORT NSString *const ActivityStartTime;
FOUNDATION_EXPORT NSString *const ActivityEndTime;
// Coupon Code
FOUNDATION_EXPORT NSString *const ActivityCode;

// Countdown Text
FOUNDATION_EXPORT NSString *const ActivityCountDownText;

#define ActivitySharedHandler [ActivityHandler sharedHandler]

FOUNDATION_EXPORT NSNotificationName const ActivityPresaleStatusDidChanged;
FOUNDATION_EXPORT NSNotificationName const ActivityCountDownStatusDidChanged;
FOUNDATION_EXPORT NSNotificationName const ActivityCouponCodeStatusDidChanged;

@interface ActivityHandler : NSObject
@property (nonatomic, readonly, assign) BOOL isActivityCountDownViewAvaliable;
@property (nonatomic, readonly, assign) BOOL isActivityPreSaleViewAvaliable;
@property (nonatomic, readonly, assign) BOOL isActivityCouponCodeAvaliable;
@property (nonatomic, readonly, strong) NSDateFormatter *fmt;
@property (nonatomic, assign) BOOL hasClosedPreSaleView;
@property (nonatomic, strong) TopNotificationModel *data;
@property (nonatomic, assign) NSTimeInterval countDownInterval;
@property (nonatomic, readonly, assign) CGSize activity_presale_size;
@property (nonatomic, readonly, assign) CGSize activity_count_down_size;

+ (instancetype)sharedHandler;

- (void)startMonitoring;

@end
