//
//  AZAlert.h
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZAlert : NSObject

/*
 @prama title: Alert title,UIBoldFontSize(18) by default
 @prama detail: Alert detail,UISystemFontSize(12) by default
 @prama preferred: make item's text color to red,YES to confirm,NO to cancel.
 */

+ (instancetype)alertWithTitle:(NSString *)title detailText:(NSString *)detail preferConfirm:(BOOL)preferred;

/*
 @prama title: Alert title,UIBoldFontSize(18) by default
 @prama details: Multiple detail texts,UISystemFontSize(12) by default
 @prama preferred: make item's text color to red,YES to confirm,NO to cancel.
 */

+ (instancetype)alertWithTitle:(NSString *)title detailTexts:(NSArray <NSString *>*)details preferConfirm:(BOOL)preferred;

/*
 @discusstion
     will be hidden automatically when cancel/confirm item did clicked.
     action block will be called after hidden.
 */
- (void)addCancelItemWithTitle:(NSString *)title action:(dispatch_block_t)action;

- (void)addConfirmItemWithTitle:(NSString *)title action:(dispatch_block_t)action;


/*
 @discusstion
     Add header image to alert.default by nil.
 */


- (void)addHeaderImage:(UIImage *)img;

- (void)show;
- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete;

@end
