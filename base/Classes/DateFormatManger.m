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

+ (NSString *)stringOfDate:(NSDate *)date forStyle:(NSDateFormatterStyle)style {
    return [[DateFormatManger dateFormatterForStyle:style] stringFromDate:date];
}

+ (NSDate *)dateOfString:(NSString *)string forStyle:(NSDateFormatterStyle)style {
    return [[DateFormatManger dateFormatterForStyle:style] dateFromString:string];
}

@end
