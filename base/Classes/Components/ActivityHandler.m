//
//  ActivityHandler.m
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "ActivityHandler.h"
#import "Network.h"
#import "TopNotificationView.h"
#import <QMUIKit/QMUICommonDefines.h>

#define TIME_INTERVAL_GAP (3600*24)
#define START_PRESALE_TEXT TIME_INTERVAL_GAP*2

//预售
NSString *const PreSaleCountDownStartTime   = @"2018-08-29 00:00:00";
NSString *const PreSaleCountDownEndTime     = @"2018-09-03 23:59:59";
//黑色倒计时
NSString *const ActivityCountDownStartTime  = @"2018-09-04 00:00:00";
NSString *const ActivityCountDownEndTime    = @"2018-09-04 21:59:59";
//真正的活动时间范围
NSString *const ActivityStartTime           = @"2018-09-02 00:00:00";
NSString *const ActivityEndTime             = @"2018-09-04 23:59:59";

NSString *const ActivityCode                = @"LABORDAY";

NSNotificationName const ActivityPresaleStatusDidChanged = @"ActivityPresaleStatusDidChanged";
NSNotificationName const ActivityCountDownStatusDidChanged = @"ActivityCountDownStatusDidChanged";
NSNotificationName const ActivityCouponCodeStatusDidChanged = @"ActivityCouponCodeStatusDidChanged";

@interface ActivityHandler ()
@property (nonatomic, readwrite, strong) NSDateFormatter *fmt;
@property (nonatomic, readwrite, strong) RACSignal <NSNumber *> *activityTimeIntervalSignal;
@property (nonatomic, readwrite, strong) RACSignal <TopNotificationModel *> *presaleTextSignal;
@property (nonatomic, readwrite, assign) CGSize activity_presale_size;
@property (nonatomic, readwrite, assign) CGSize activity_count_down_size;
@end

@implementation ActivityHandler

+ (instancetype)sharedHandler {
    static dispatch_once_t onceToken;
    static ActivityHandler *handler = nil;
    dispatch_once(&onceToken, ^{
        handler = [[ActivityHandler alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
        [NSTimeZone setDefaultTimeZone:timeZone];
        handler.activity_presale_size = CGSizeZero;
        handler.activity_count_down_size = CGSizeMake(SCREEN_WIDTH, 37.f);
    });
    return handler;
}
- (CGSize)activity_presale_size {
    if (!CGSizeEqualToSize(_activity_presale_size, CGSizeZero)) {
        return _activity_presale_size;
    }
    _activity_presale_size = [TopNotificationView expectedSize:self.data];
    return _activity_presale_size;
}
- (void)startMonitoring {
    @weakify(self);
    RACSignal *time = [[[[RACSignal interval:1.f onScheduler:[RACScheduler mainThreadScheduler]] startWith:NSDate.date] takeUntilBlock:^BOOL(NSDate * _Nullable x) {
        @strongify(self);
        NSComparisonResult result = [x compare:[self.fmt dateFromString:ActivityEndTime]];
        if (result == NSOrderedDescending) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ActivityPresaleStatusDidChanged object:@(NO)];
            [[NSNotificationCenter defaultCenter] postNotificationName:ActivityCountDownStatusDidChanged object:@(NO)];
            [[NSNotificationCenter defaultCenter] postNotificationName:ActivityCouponCodeStatusDidChanged object:@(NO)];
        }
        return result == NSOrderedDescending;
    }] replayLast];
    [[[time map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return @(self.isActivityCouponCodeAvaliable);
    }] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ActivityCouponCodeStatusDidChanged object:x];
    }];
    [[[time map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return @(self.isActivityPreSaleViewAvaliable);
    }] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ActivityPresaleStatusDidChanged object:x];
    }];
    [[[time map:^id _Nullable(id  _Nullable value) {
        @strongify(self);
        return @(self.isActivityCountDownViewAvaliable);
    }] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ActivityCountDownStatusDidChanged object:x];
    }];
    self.presaleTextSignal = [[time map:^id _Nullable(NSDate * _Nullable value) {
        @strongify(self);
        if (self.hasClosedPreSaleView) {
            return [self generateTopNotificationActivityData:nil];
        }
        NSDateFormatter *fmt = self.fmt;
        NSDate *endTime = [fmt dateFromString:PreSaleCountDownEndTime];
        NSInteger timeInterval = floor([endTime timeIntervalSinceDate:NSDate.date]);
        
        if (timeInterval > TIME_INTERVAL_GAP * 2 && timeInterval < TIME_INTERVAL_GAP * 7) {
            NSInteger remainingDays = timeInterval/TIME_INTERVAL_GAP;
            NSString *text = [NSString stringWithFormat:@"%ld DAYS UNTIL LABOR DAY SALE | %@ OFF ALL ACCESSORIES" ,remainingDays-1, @"10%"];
            return [self generateTopNotificationActivityData:text];
        }
        if (timeInterval <= TIME_INTERVAL_GAP * 2 && timeInterval > 0) {
            NSInteger remainingDays = timeInterval/TIME_INTERVAL_GAP;
            NSString *text = nil;
            text = [NSString stringWithFormat:@"%@ OFF ALL ACCESSORIES | ENDS IN %ld DAYS." ,@"10%" ,remainingDays+2];
            return [self generateTopNotificationActivityData:text];
        }
        return [self generateTopNotificationActivityData:nil];
    }] distinctUntilChanged];
    self.activityTimeIntervalSignal = [[[[[time map:^id _Nullable(NSDate * _Nullable value) {
        return @(self.isActivityCountDownViewAvaliable);
    }] distinctUntilChanged] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] map:^id _Nullable(id  _Nullable value) {
        NSDateFormatter *fmt = self.fmt;
        NSDate *endTime = [fmt dateFromString:ActivityCountDownEndTime];
        return @(floor([endTime timeIntervalSinceDate:NSDate.date]));
    }] distinctUntilChanged];
}

- (BOOL)isActivityPreSaleViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:PreSaleCountDownStartTime to:PreSaleCountDownEndTime] && !self.hasClosedPreSaleView;
}

- (BOOL)isActivityCountDownViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:ActivityCountDownStartTime to:ActivityCountDownEndTime];
}

- (BOOL)isActivityCouponCodeAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:ActivityStartTime to:ActivityEndTime];
}

- (void)setHasClosedPreSaleView:(BOOL)hasClosedPreSaleView {
    [[NSUserDefaults standardUserDefaults] setObject:hasClosedPreSaleView?[self.fmt stringFromDate:NSDate.date]:nil forKey:@"has_closed_presale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:ActivityPresaleStatusDidChanged object:@(!hasClosedPreSaleView)];
}

- (BOOL)hasClosedPreSaleView {
   NSString *closeTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"has_closed_presale"];
    if (closeTime) {
        BOOL isSameDay = [[NSCalendar currentCalendar] isDate:[self.fmt dateFromString:closeTime] inSameDayAsDate:NSDate.date];
        if (isSameDay) {
            return YES;
        } else {
            [self setHasClosedPreSaleView:NO];
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSDateFormatter *)fmt {
    if (!_fmt) {
        _fmt = [[NSDateFormatter alloc]init];
        [_fmt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
        _fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _fmt;
}

- (BOOL)isActivityAvaliableFrom:(NSString *)start to:(NSString *)end {
    NSTimeInterval startInterval = [[self.fmt dateFromString:start] timeIntervalSince1970]*1000;
    NSTimeInterval endInterval = [[self.fmt dateFromString:end] timeIntervalSince1970]*1000;
    NSTimeInterval nowInterval = [NSDate.date timeIntervalSince1970]*1000;
    return (startInterval < nowInterval && nowInterval < endInterval);
}

- (TopNotificationModel *)generateTopNotificationActivityData:(NSString *)aText {
    if (aText) {
        if (!_data) {
            _data = [TopNotificationModel new];
            _data.background_color = @"FDE2EC";
            _data.alignment = NSTextAlignmentCenter;
            _data.font_size = 12;
            _data.display_template = YES;
            _data.text = aText;
            TopNotificationAttributesModel *_attribute1 = [TopNotificationAttributesModel new];
            _attribute1.type = TopNotifyLabelAttributesTypeFontColor;
            _attribute1.value = @"333333";
            _attribute1.start = 0;
            _attribute1.length = aText.length;
            _data.attributes = @[_attribute1];
        } else {
            if (![_data.text isEqualToString:aText]) {
                _data = nil;
                _data = [self generateTopNotificationActivityData:aText];
            }
        }
    } else {
        _data = nil;
    }
    return _data;
}

@end
