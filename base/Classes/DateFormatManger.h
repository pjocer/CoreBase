//
//  DateFormatManger.h
//  AFNetworking
//
//  Created by abc on 2018/1/25.
//

#import <Foundation/Foundation.h>

@interface DateFormatManger : NSObject

+ (NSDateFormatter *)dateFormatterForStyle:(NSDateFormatterStyle)style;

+ (NSString *)stringOfDate:(NSDate *)date forStyle:(NSDateFormatterStyle)style;
+ (NSDate *)dateOfString:(NSString *)string forStyle:(NSDateFormatterStyle)style;

@end
