//
//  DrilldropMenuItem.h
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrilldropMenuItem : NSObject

/// initial option index is 0
- (instancetype)initWithTitle:(NSString *)title
                      options:(nullable NSArray<NSString *> *)options
                        image:(UIImage *)image
                selectedImage:(nullable UIImage *)selectedImage;

- (instancetype)initWithTitle:(NSString *)title
                      options:(nullable NSArray<NSString *> *)options
                        image:(UIImage *)image
                selectedImage:(nullable UIImage *)selectedImage
           initialOptionIndex:(NSUInteger)initialOptionIndex NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly, strong) RACSignal<DrilldropMenuItem *> *didClickSignal;
@property (nonatomic, assign) NSUInteger selectedOptionIndex;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, copy, nullable) NSArray<NSString *> *options;

@property (nonatomic, readonly, strong) UIImage *image;
@property (nonatomic, readonly, strong) UIImage *selectedImage;

/// Default NO. if NO, always use title. otherwise first word of option will be used.
@property (nonatomic, assign) BOOL usingOptionAsTitle;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
