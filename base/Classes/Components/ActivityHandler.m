//
//  ActivityHandler.m
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "ActivityHandler.h"
#import "Network.h"

NSString *const CyberMondayCountDownEndTime = @"2017-11-27 21:00:00";
NSString *const PreSaleCountDownEndTime = @"2017-11-28 00:00:00";
NSString *const CyberMondayActivityCode = @"cyber17";
NSString *const CyberMondayCountDownViewDisplayNotification = @"CyberMondayCountDownViewDisplayNotification";
NSString *const CyberMondayPreSaleViewDisplayNotification = @"CyberMondayPreSaleViewDisplayNotification";

@interface ActivityHandler ()
@property (nonatomic, strong) RACScopedDisposable *_dispose;
@end

@implementation ActivityHandler

+ (instancetype)sharedHandler {
    static dispatch_once_t onceToken;
    static ActivityHandler *handler = nil;
    dispatch_once(&onceToken, ^{
        handler = [[ActivityHandler alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
        [NSTimeZone setDefaultTimeZone:timeZone];
    });
    return handler;
}

- (void)startMonitoring {
//    [[[RACSignal interval:1.f onScheduler:[RACScheduler mainThreadScheduler]] startWith:NSDate.date] subscribeNext:^(NSDate * _Nullable x) {
//        
//    }];
}

- (BOOL)isPreSaleViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-20 00:00:00" to:PreSaleCountDownEndTime];
}

- (BOOL)isCyberMondayViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-27 09:00:00" to:CyberMondayCountDownEndTime];
}

- (BOOL)isCyberMondayCouponCodeAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-27 00:00:00" to:@"2017-11-27 24:00:00"];
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
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return df;
}

- (BOOL)isActivityAvaliableFrom:(NSString *)start to:(NSString *)end {
    NSTimeInterval startInterval = [[self.fmt dateFromString:start] timeIntervalSince1970]*1000;
    NSTimeInterval endInterval = [[self.fmt dateFromString:end] timeIntervalSince1970]*1000;
    NSTimeInterval nowInterval = [NSDate.date timeIntervalSince1970]*1000;
    return (startInterval < nowInterval && nowInterval < endInterval);
}



@end
