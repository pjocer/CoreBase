//
//  RACSignal+NSURLError.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "NSError+Networking.h"

FOUNDATION_EXPORT NSErrorDomain const AzazieErrorDomain;
FOUNDATION_EXPORT NSString *const AzazieErrorDomainErrorsKey;

FOUNDATION_EXPORT NSInteger const AzazieErrorMultipleErrors;
FOUNDATION_EXPORT NSInteger const AzazieErrorSingleError;

@interface RACSignal<__covariant ValueType> (NSURLError)

// catch URLError and then send nil to next
- (RACSignal<ValueType> *)catchURLError;
- (RACSignal<ValueType> *)catchNSURLError;
- (RACSignal<ValueType> *)catchNSURLErrorCancelled;
- (RACSignal<ValueType> *)catchNSURLErrorNoResponse;

// zips the errors in the receiver with those of the given signal to create RACTuples or errors to send.
- (RACSignal *)zipErrorWith:(RACSignal *)signal;
+ (RACSignal<RACTuple *> *)zipErrors:(id<NSFastEnumeration>)signals;

// do URLError with customize alert, and then send an error.
- (RACSignal<ValueType> *)doURLErrorAlert;
- (RACSignal<ValueType> *)doNSURLErrorAlert;
- (RACSignal<ValueType> *)doAzazieURLErrorAlert;
@end
