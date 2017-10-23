//
//  RACSignal+NSURLError.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal<__covariant ValueType> (NSURLError)

// catch URLError and then send nil to next
- (RACSignal<ValueType> *)catchURLError;
- (RACSignal<ValueType> *)catchNSURLError;
- (RACSignal<ValueType> *)catchNSURLErrorCancelled;
- (RACSignal<ValueType> *)catchNSURLErrorNoResponse;

// Zips the errors in the receiver with those of the given signal to create RACTuples or errors to send.
- (RACSignal *)zipErrorWith:(RACSignal *)signal;
+ (RACSignal<RACTuple *> *)zipErrors:(id<NSFastEnumeration>)signals;

// do URLError with customize alert, and then send an error.
- (RACSignal<ValueType> *)doNSURLErrorAlert;
@end
