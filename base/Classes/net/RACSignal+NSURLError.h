//
//  RACSignal+NSURLError.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal<__covariant ValueType> (NSURLError)

- (RACSignal<ValueType> *)catchNSURLErrorWithViewController:(__weak UIViewController *)viewController;
- (RACSignal<ValueType> *)catchNSURLError;
- (RACSignal<ValueType> *)catchNSURLErrorCancelled;

- (RACSignal<ValueType> *)catchNSURLErrorNoResponse;

- (RACSignal<ValueType> *)doNSURLErrorWithViewController:(__weak UIViewController *)viewController;


- (RACSignal<ValueType> *)catchURLErrorWithViewController:(__weak UIViewController *)viewController DEPRECATED_ATTRIBUTE;

@end
