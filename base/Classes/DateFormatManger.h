//
//  DateFormatManger.h
//  AFNetworking
//
//  Created by abc on 2018/1/25.
//

#import <Foundation/Foundation.h>

@interface DateFormatManger : NSObject

+ (NSDateFormatter *)dateFormatterForStyle:(NSDateFormatterStyle)style;
+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format;
+ (NSDateFormatter *)dateFormatterForMode:(UIDatePickerMode)dateMode;

+ (NSString *)stringOfDate:(NSDate *)date forStyle:(NSDateFormatterStyle)style;
+ (NSDate *)dateOfString:(NSString *)string forStyle:(NSDateFormatterStyle)style;

+ (NSString *)stringOfDate:(NSDate *)date forFormat:(NSString *)format;
+ (NSDate *)dateOfString:(NSString *)string forFormat:(NSString *)format;

+ (NSString *)stringOfDate:(NSDate *)date forMode:(UIDatePickerMode)mode;
+ (NSDate *)dateOfString:(NSString *)string forMode:(UIDatePickerMode)mode;

@end
