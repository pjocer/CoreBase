//
//  AZAlert.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZAlert : NSObject

+ (instancetype)alertWithTitle:(NSString *)title detailText:(NSString *)detail;

// will be hidden automatically when cancel/confirm did clicked.
// action block will be called after hidden.
- (void)addCancelItemWithTitleAttributes:(NSDictionary *)attr title:(NSString *)title action:(dispatch_block_t)action;

- (void)addConfirmItemWithTitleAttributes:(NSDictionary *)attr title:(NSString *)title action:(dispatch_block_t)action;

- (void)addHeaderImage:(UIImage *)img;

- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete;

@end
