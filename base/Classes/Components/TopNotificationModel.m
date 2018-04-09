//
//  TopNotificationModel.m
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import "TopNotificationModel.h"

@implementation TopNotificationAttributesModel
- (NSRange)effect_range {
    return NSMakeRange(self.start, self.length);
}
@end

@implementation TopNotificationModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"attributes":TopNotificationAttributesModel.class};
}
@end
