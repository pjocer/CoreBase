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
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    
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
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    
    return dateFormatter;
}

+ (NSString *)stringOfDate:(NSDate *)date forStyle:(NSDateFormatterStyle)style {
    return date ? [[DateFormatManger dateFormatterForStyle:style] stringFromDate:date] : nil;
}

+ (NSDate *)dateOfString:(NSString *)string forStyle:(NSDateFormatterStyle)style {
    return string ? [[DateFormatManger dateFormatterForStyle:style] dateFromString:string] : nil;
}

+ (NSString *)stringOfDate:(NSDate *)date forFormat:(NSString *)format {
    return date ? [[DateFormatManger dateFormatterForFormat:format] stringFromDate:date] : nil;
}

+ (NSDate *)dateOfString:(NSString *)string forFormat:(NSString *)format {
    return string ? [[DateFormatManger dateFormatterForFormat:format] dateFromString:string] : nil;
}

+ (NSString *)stringOfDate:(NSDate *)date forMode:(UIDatePickerMode)mode {
    return date ? [[DateFormatManger dateFormatterForMode:mode] stringFromDate:date] : nil;
}

+ (NSDate *)dateOfString:(NSString *)string forMode:(UIDatePickerMode)mode {
    return string ? [[DateFormatManger dateFormatterForMode:mode] dateFromString:string] : nil;
}

@end
