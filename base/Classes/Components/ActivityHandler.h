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

FOUNDATION_EXPORT NSString *const ActivityCountDownEndTime;
FOUNDATION_EXPORT NSString *const ActivityCountDownStartTime;
FOUNDATION_EXPORT NSString *const PreSaleCountDownEndTime;
FOUNDATION_EXPORT NSString *const PreSaleCountDownStartTime;
FOUNDATION_EXPORT NSString *const ActivityCode;

#define ActivitySharedHandler [ActivityHandler sharedHandler]

@interface ActivityHandler : NSObject
@property (nonatomic, readonly, assign) BOOL isActivityCountDownViewAvaliable;
@property (nonatomic, readonly, assign) BOOL isActivityPreSaleViewAvaliable;
@property (nonatomic, readonly, assign) BOOL isActivityCouponCodeAvaliable;
@property (nonatomic, readonly, strong) NSDateFormatter *fmt;
@property (nonatomic, assign) BOOL hasClosedPreSaleView;
@property (nonatomic, readonly, strong) RACSubject <NSDate *> *activitySignal;
@property (nonatomic, readonly, strong) RACSubject <NSDate *> *presaleSignal;
@property (nonatomic, readonly, strong) RACSignal <NSNumber *> *activityTimeIntervalSignal;
@property (nonatomic, readonly, strong) RACSignal <NSString *> *presaleTextSignal;
@property (nonatomic, strong) TopNotificationModel *data;
@property (nonatomic, readonly, assign) CGSize activity_presale_size;
@property (nonatomic, readonly, assign) CGSize activity_count_down_size;

+ (instancetype)sharedHandler;

- (void)startMonitoring;

@end
