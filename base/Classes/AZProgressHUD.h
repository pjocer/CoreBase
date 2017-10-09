//
//  AZProgressHUD.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface AZProgressHUD : MBProgressHUD

- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow;
- (AZProgressHUD *(^)(BOOL isBlocked))blocked;
- (AZProgressHUD *(^)(BOOL autoremoveOnHidden))autoremoveOnHidden;
- (AZProgressHUD *(^)(CGFloat graceTime))grace;
- (AZProgressHUD *(^)(NSString *text))text;
- (AZProgressHUD *(^)(NSString *detailText))detailText;

+ (instancetype)showAzazieHUD;
+ (void)hiddenAnimated:(BOOL)isAnimated;

@end
