//
//  TopNotificationLabel.h
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNotificationModel.h"

@interface TopNotificationView : UIView
@property (nonatomic, strong) TopNotificationModel *model;
@property (nonatomic, copy) void(^clickedLink)(NSURL *url);
@property (nonatomic, copy) dispatch_block_t clickedAction;
@property (nonatomic, copy) dispatch_block_t clickedClose;
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithData:(TopNotificationModel *)data;
+ (CGSize)expectedSize;
+ (CGSize)expectedSize:(TopNotificationModel *)model;
@end
