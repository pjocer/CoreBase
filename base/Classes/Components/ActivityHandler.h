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
