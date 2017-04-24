//
//  RACSignal+Util.h
//  base
//
//  Created by Demi on 23/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal<__covariant ValueType> (Util)

- (RACSignal<ValueType> *)hudWithView:(__weak UIView *)view;
- (RACSignal<ValueType> *)hudWithViewController:(__weak UIViewController *)viewController;

- (RACSignal<ValueType> *)catchURLErrorWithViewController:(__weak UIViewController *)viewController;

@end
