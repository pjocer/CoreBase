//
//  ActivityHandler.m
//  mobile
//
//  Created by Jocer on 2017/11/7.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "ActivityHandler.h"

NSString *const CyberMondayCountDownEndTime = @"2017-11-11 05:10:00";
NSString *const PreSaleCountDownEndTime = @"2017-11-19 00:00:00";
NSString *const CyberMondayActivityCode = @"cyber15";

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

- (BOOL)isPreSaleViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-11 00:00:00" to:PreSaleCountDownEndTime];
}

- (BOOL)isCyberMondayViewAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-11 05:00:00" to:CyberMondayCountDownEndTime];
}

- (BOOL)isCyberMondayCouponCodeAvaliable {
    return [[ActivityHandler sharedHandler] isActivityAvaliableFrom:@"2017-11-11 06:30:00" to:@"2017-11-11 06:35:00"];
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
