//
//  NotificationLoader.h
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopNotificationView.h"

#define NotificationSharedLoader [NotificationLoader sharedLoader]

FOUNDATION_EXPORT NSNotificationName const TopNotificationDidUpdated;

@interface NotificationLoader : NSObject

@property (nonatomic, strong) TopNotificationModel *top_model;

+ (instancetype)sharedLoader;

- (void)execute;

@end
