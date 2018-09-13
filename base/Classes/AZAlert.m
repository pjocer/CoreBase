//
//  AZAlert.m
//  mobile
//
//  Created by Jocer on 2017/9/21.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "AZAlert.h"
#import "UIView+SeparatorLine.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AZProgressHUD.h"
#import "util.h"
#import "UIFont+LQFont.h"

#define animate_duration 0.3

@interface AZAlert ()
@property (nonatomic, strong) QMUIAlertController *QMUIAlert;
@end

@implementation AZAlert

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AZAlert *alert = nil;
    dispatch_once(&onceToken, ^{
        alert = [AZAlert new];
    });
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title detailText:(NSString *)detail preferConfirm:(BOOL)preferred {
    return [self alertWithTitle:title detailTexts:detail?@[detail]:@[] preferConfirm:preferred];
}

+ (instancetype)alertWithTitle:(NSString *)title detailTexts:(NSArray<NSString *> *)details preferConfirm:(BOOL)preferred {
    AZAlert *alert = [AZAlert sharedInstance];
    [alert initAlertWithTitle:title messages:details];
    return alert;
}

- (void)initAlertWithTitle:(NSString *)title messages:(NSArray<NSString *> *)messages {
    self.QMUIAlert = [[QMUIAlertController alloc] initWithTitle:title message:[self processedMessageForMessages:messages] preferredStyle:QMUIAlertControllerStyleAlert];
    [self handleAlertControllerAttributes:self.QMUIAlert];
}

- (void)handleAlertControllerAttributes:(QMUIAlertController *)alertController {
    alertController.alertButtonHeight = 49.f;
    alertController.alertContentCornerRadius = 5.f;
    alertController.alertTitleMessageSpacing = 15.f;
    alertController.alertHeaderBackgroundColor = UIColorWhite;
    alertController.alertButtonBackgroundColor = UIColorWhite;
    alertController.alertHeaderInsets = UIEdgeInsetsMake(48.f, 48.f, 32.f, 48.f);
    alertController.alertContentMaximumWidth = [UIScreen mainScreen].bounds.size.width - (80.f * [UIScreen mainScreen].bounds.size.width / 375.f);
    
    NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *messageAttributes = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] init];
    
    titleAttributes[NSFontAttributeName] = UIFontBoldMake(18.f);
    titleAttributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"#333333");
    
    buttonAttributes[NSFontAttributeName] = UIFontBoldMake(15.f);
    buttonAttributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"#E8437B");
    
    messageAttributes[NSFontAttributeName] = UIFontMake(12.f);
    messageAttributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"#333333");
    messageAttributes[NSParagraphStyleAttributeName] = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:18.f lineBreakMode:NSLineBreakByWordWrapping];
    
    cancelButtonAttributes[NSFontAttributeName] = UIFontBoldMake(15.f);
    cancelButtonAttributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"#333333");
    
    alertController.alertTitleAttributes = titleAttributes;
    alertController.alertButtonAttributes = buttonAttributes;
    alertController.alertMessageAttributes = messageAttributes;
    alertController.alertCancelButtonAttributes = cancelButtonAttributes;
    
    UIView *maskView = [self.QMUIAlert valueForKey:@"maskView"];
    maskView.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .7f);
}

- (NSString *)processedMessageForMessages:(NSArray<NSString *> *)messages {
    if (messages.count == 1) {
        return messages[0];
    }
    if (messages.count > 1) {
        NSString *dispalyMsg = [NSString stringWithFormat:@"We find %ld problems below:", messages.count];
        for (NSString *message in messages) {
            dispalyMsg = [dispalyMsg stringByAppendingString:[@"\n•  " stringByAppendingString:message]];
        }
        return dispalyMsg;
    }
    return @"Unknow details describtion";
}

- (void)addHeaderImage:(UIImage *)img {
    if (!img) {
        return;
    }
    UIImageView *image = [[UIImageView alloc] initWithImage:img];
    
    UIView *containerView = [self.QMUIAlert valueForKey:@"containerView"];
    UIView *scrollWrapView = [self.QMUIAlert valueForKey:@"scrollWrapView"];
    UIScrollView *headerScrollView = [self.QMUIAlert valueForKey:@"headerScrollView"];
    
    containerView.clipsToBounds = NO;
    scrollWrapView.clipsToBounds = NO;
    headerScrollView.clipsToBounds = NO;
    
    [headerScrollView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerScrollView.mas_top);
        make.centerX.equalTo(headerScrollView);
    }];
    
    [headerScrollView bringSubviewToFront:image];
}

- (void)addCancelItemWithTitle:(NSString *)title action:(dispatch_block_t)action {
    QMUIAlertAction *QMUIAction = [QMUIAlertAction actionWithTitle:title style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *qaction) {
        if (action) {
            action();
        }
    }];
    [self.QMUIAlert addAction:QMUIAction];
}

- (void)addConfirmItemWithTitle:(NSString *)title action:(dispatch_block_t)action {
    QMUIAlertAction *QMUIAction = [QMUIAlertAction actionWithTitle:title style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *qaction) {
        if (action) {
            action();
        }
    }];
    [self.QMUIAlert addAction:QMUIAction];
}

- (void)show {
    [self showWithAnimated:YES completion:NULL withoutMask:NO];
}

- (void)showWithoutMaskView {
    [self showWithAnimated:YES completion:NULL withoutMask:YES];
}

- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete {
    [self showWithAnimated:animated completion:complete withoutMask:NO];
}

- (void)showWithAnimated:(BOOL)animated completion:(dispatch_block_t)complete withoutMask:(BOOL)shouldMask {
    if (shouldMask) {
        UIView *maskView = [self.QMUIAlert valueForKey:@"maskView"];
        maskView.backgroundColor = UIColorClear;
    }
    
    [self.QMUIAlert showWithAnimated:animated];
    
    if (complete) complete();
}

@end
