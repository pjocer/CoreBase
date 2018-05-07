//
//  TopNotificationModel.h
//  mobile
//
//  Created by Jocer on 2018/4/9.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
typedef enum : NSUInteger {
    TopNotifyLabelAttributesTypeFontColor,
    TopNotifyLabelAttributesTypeBold,
    TopNotifyLabelAttributesTypeUnderline,
    TopNotifyLabelAttributesTypeHref
} TopNotifyLabelAttributesType;

@interface TopNotificationAttributesModel : NSObject
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSRange effect_range;
@property (nonatomic, assign) TopNotifyLabelAttributesType type;
@property (nonatomic, strong) id value;
@end

@interface TopNotificationModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *background_color;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) NSInteger font_size;
@property (nonatomic, assign) BOOL display_template;
@property (nonatomic, strong) NSArray <TopNotificationAttributesModel *> *attributes;
@end
