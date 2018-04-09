//
//  NotificationLoader.m
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import "NotificationLoader.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "Network.h"
#import "RACSignal+ResponseToModel.h"

#define TOP_NOTIFICATION_PATH @"notifications/top"

NSNotificationName const TopNotificationDidUpdated = @"TopNotificationDidUpdate";

@interface NotificationLoader ()

@end

@implementation NotificationLoader

+ (instancetype)sharedLoader {
    static dispatch_once_t onceToken;
    static NotificationLoader *loader = nil;
    dispatch_once(&onceToken, ^{
        loader = [[NotificationLoader alloc] init];
    });
    return loader;
}

- (void)execute {
    [[RACObserve(self, top_model) skip:1] subscribeNext:^(id  _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TopNotificationDidUpdated object:x];
    }];
    RAC(self, top_model) = [[Network.APISession rac_GET:TOP_NOTIFICATION_PATH parameters:nil] tryMapResponseToModel:TopNotificationModel.class];
}

@end
