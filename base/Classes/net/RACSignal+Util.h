//
//  RACSignal+Util.h
//  base
//
//  Created by Demi on 23/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal<__covariant ValueType> (Util)

- (RACSignal<ValueType> *)hud;
- (RACSignal<ValueType> *)hudWithView:(__weak UIView *)view;
- (RACSignal<ValueType> *)hudWithViewController:(__weak UIViewController *)viewController;

/// 如果error, completed先完成，那么不会执行, 用于主动dispose
- (RACSignal<ValueType> *)beforeDispose:(void(^)(void))block;

@end




