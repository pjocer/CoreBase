//
//  DateFormatManger.m
//  AFNetworking
//
//  Created by abc on 2018/1/25.
//

#import "DateFormatManger.h"

@implementation DateFormatManger

+ (NSDateFormatter *)dateFormatterForStyle:(NSDateFormatterStyle)style {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterForMode:(UIDatePickerMode)dateMode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (dateMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    return dateFormatter;
}

+ (NSString *)stringOfDate:(NSDate *)date forStyle:(NSDateFormatterStyle)style {
    return [[DateFormatManger dateFormatterForStyle:style] stringFromDate:date];
}

+ (NSDate *)dateOfString:(NSString *)string forStyle:(NSDateFormatterStyle)style {
    return [[DateFormatManger dateFormatterForStyle:style] dateFromString:string];
}

+ (NSString *)stringOfDate:(NSDate *)date forFormat:(NSString *)format {
    return [[DateFormatManger dateFormatterForFormat:format] stringFromDate:date];
}

+ (NSDate *)dateOfString:(NSString *)string forFormat:(NSString *)format {
    return [[DateFormatManger dateFormatterForFormat:format] dateFromString:string];
}

+ (NSString *)stringOfDate:(NSDate *)date forMode:(UIDatePickerMode)mode {
    return [[DateFormatManger dateFormatterForMode:mode] stringFromDate:date];
}

+ (NSDate *)dateOfString:(NSString *)string forMode:(UIDatePickerMode)mode {
    return [[DateFormatManger dateFormatterForMode:mode] dateFromString:string];
}

@end
