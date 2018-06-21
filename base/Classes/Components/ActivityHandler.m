//
//  ActivityHandler.m
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "ActivityHandler.h"
#import "Network.h"

//NSString *const ActivityCountDownStartTime  = @"2018-07-02 00:00:00";
//NSString *const ActivityCountDownEndTime    = @"2018-07-03 23:59:59";
//NSString *const PreSaleCountDownStartTime   = @"2018-06-25 00:00:00";
//NSString *const PreSaleCountDownEndTime     = @"2018-07-01 23:59:59";
//NSString *const ActivityEndTime             = @"2018-07-04 00:00:00";
//NSString *const ActivityCode                = @"FREEDOM";

NSString *const ActivityCountDownStartTime  = @"2018-06-21 02:20:00";
NSString *const ActivityCountDownEndTime    = @"2018-06-21 12:30:00";
NSString *const PreSaleCountDownStartTime   = @"2018-06-18 23:50:30";
NSString *const PreSaleCountDownEndTime     = @"2018-06-29 23:46:30";
NSString *const ActivityStartTime           = @"2018-06-19 00:00:00";
NSString *const ActivityEndTime             = @"2018-06-29 00:00:00";
NSString *const ActivityCode                = @"plist1";

@interface ActivityHandler ()
@property (nonatomic, strong) RACScopedDisposable *_dispose;
@property (nonatomic, readwrite, strong) NSDateFormatter *fmt;
@property (nonatomic, readwrite, strong) RACReplaySubject <NSDate *>*activitySignal;
@property (nonatomic, readwrite, strong) RACReplaySubject <NSDate *>*presaleSignal;
@property (nonatomic, readwrite, strong) RACSignal <NSNumber *> *activityTimeIntervalSignal;
@property (nonatomic, readwrite, strong) RACSignal <NSString *> *presaleTextSignal;
@property (nonatomic, readwrite, strong) TopNotificationModel *data;
@end

@implementation ActivityHandler

+ (instancetype)sharedHandler {
    static dispatch_once_t onceToken;
    static ActivityHandler *handler = nil;
    dispatch_once(&onceToken, ^{
        handler = [[ActivityHandler alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
        [NSTimeZone setDefaultTimeZone:timeZone];
        handler.activitySignal = [RACReplaySubject subject];
        handler.presaleSignal = [RACReplaySubject subject];
        handler.activityTimeIntervalSignal = [RACReplaySubject subject];
        handler.presaleTextSignal = [RACReplaySubject subject];
    });
    return handler;
}

- (void)startMonitoring {
    @weakify(self);
    [self setHasClosedPreSaleView:NO];
    self._dispose = [[[[RACSignal interval:1.f onScheduler:[RACScheduler mainThreadScheduler]] startWith:NSDate.date] takeUntilBlock:^BOOL(NSDate * _Nullable x) {
        @strongify(self);
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];
        NSTimeInterval interval = [zone secondsFromGMTForDate:x];
        NSDate *alterred = [x dateByAddingTimeInterval:interval];
        NSComparisonResult result = [alterred compare:[self.fmt dateFromString:ActivityEndTime]];
        if (result == NSOrderedDescending) {
            [self.presaleSignal sendNext:x];
            [self.activitySignal sendNext:x];
        }
        return result == NSOrderedDescending;
    }] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        [self.presaleSignal sendNext:x];
        [self.activitySignal sendNext:x];
    }].asScopedDisposable;
    self.presaleTextSignal = [[[self.presaleSignal map:^id _Nullable(NSDate * _Nullable value) {
        @strongify(self);
        if (self.hasClosedPreSaleView) {
            return nil;
        }
        NSDateFormatter *fmt = self.fmt;
        NSDate *endTime = [fmt dateFromString:PreSaleCountDownEndTime];
        NSInteger timeInterval = floor([endTime timeIntervalSinceDate:NSDate.date]);
        NSInteger remainingDays = timeInterval/(3600*24);
        NSString *text = nil;
        if (remainingDays == 1) {
            text = [NSString stringWithFormat:@"%@ OFF ALL WEDDING DRESSES | ENDS IN 1 DAY." ,@"10%"];
        }
        if (remainingDays == 2) {
            text = [NSString stringWithFormat:@"%@ OFF ALL WEDDING DRESSES | ENDS IN %ld DAYS." ,@"10%" ,remainingDays];
        }
        if (remainingDays > 2) {
            text = [NSString stringWithFormat:@"%ld DAYS UNTIL OUR 4TH OF JULY SALE | %@ OFF ALL WEDDING DRESSES.", remainingDays, @"10%"];
        }
        return text;
    }] distinctUntilChanged] replayLast];
    self.activityTimeIntervalSignal = [[[[[self.activitySignal map:^id _Nullable(NSDate * _Nullable value) {
        return @(self.isActivityCountDownViewAvaliable);
    }] distinctUntilChanged] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] map:^id _Nullable(id  _Nullable value) {
        NSDateFormatter *fmt = self.fmt;
        NSDate *endTime = [fmt dateFromString:ActivityCountDownEndTime];
        return @(floor([endTime timeIntervalSinceDate:NSDate.date]));
    }] replayLast]  ;
}

- (BOOL)isActivityPreSaleViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:PreSaleCountDownStartTime to:PreSaleCountDownEndTime] && !self.hasClosedPreSaleView;
}

- (BOOL)isActivityCountDownViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:ActivityCountDownStartTime to:ActivityCountDownEndTime];
}

- (BOOL)isActivityCouponCodeAvaliable {
    return [self isActivityCountDownViewAvaliable];
}

- (void)setHasClosedPreSaleView:(BOOL)hasClosedPreSaleView {
    [[NSUserDefaults standardUserDefaults] setObject:hasClosedPreSaleView?[self.fmt stringFromDate:NSDate.date]:nil forKey:@"has_closed_presale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (TopNotificationModel *)data {
    if (!_data) {
        _data = [TopNotificationModel new];
        _data.background_color = @"FDE2EC";
        _data.alignment = NSTextAlignmentCenter;
        _data.font_size = 12;
        _data.display_template = YES;
        TopNotificationAttributesModel *_attribute1 = [TopNotificationAttributesModel new];
        _attribute1.type = TopNotifyLabelAttributesTypeFontColor;
        _attribute1.value = @"333333";
        TopNotificationAttributesModel *_attribute2 = [TopNotificationAttributesModel new];
        _attribute2.type = TopNotifyLabelAttributesTypeBold;
        _attribute2.value = @(YES);
        _data.attributes = @[_attribute1, _attribute2];
    }
    return _data;
}

@end
