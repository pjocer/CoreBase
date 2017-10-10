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

NS_ASSUME_NONNULL_BEGIN
// default by yes. will coverred an black mask view below hud.
- (AZProgressHUD *(^)(BOOL isCoverredWindow))coverredWindow;
// default by yes.
- (AZProgressHUD *(^)(BOOL isBlocked))blocked;
// default by yes.
- (AZProgressHUD *(^)(BOOL autoremoveOnHidden))autoremoveOnHidden;
// default by 0.5s
- (AZProgressHUD *(^)(CGFloat graceTime))grace;
// will show a label under the hud if the input-text not null
- (AZProgressHUD *(^)(NSString *text))text;
// will show a label under the text-label if the input-detailText not null
- (AZProgressHUD *(^)(NSString *detailText))detailText;
// will display in specific view and the color of mask view will be UIColorWhite alpha 0.7.
- (AZProgressHUD *(^)(UIView  *view))inView;

// display or hidden the Azazia-HUD with default configuration.
+ (instancetype)showAzazieHUD;
+ (void)hiddenAnimated:(BOOL)isAnimated;
NS_ASSUME_NONNULL_END

@end
