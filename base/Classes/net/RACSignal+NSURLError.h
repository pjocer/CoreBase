//
//  RACSignal+NSURLError.h
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "NSError+Networking.h"
#import <AFHTTPSessionManager+BaseRACSupports.h>

FOUNDATION_EXPORT NSErrorDomain const AzazieErrorDomain;
FOUNDATION_EXPORT NSString *const AzazieErrorDomainErrorsKey;

FOUNDATION_EXPORT NSInteger const AzazieErrorMultipleErrors;
FOUNDATION_EXPORT NSInteger const AzazieErrorSingleError;
FOUNDATION_EXPORT NSString *const AzazieErrorSingleErrorMessageKey;


@class AZSignalErrorAlertModel;
typedef AZSignalErrorAlertModel *(^CustomizeErrorAlert)(NSError *error);


/**
 convenience init

 @param alertText "Hmmm..." by default
 @param confirmTitle "OK" by default
 @param confirmAction OK action
 @param cancelTitle nil by default
 @param cancelAction NULL by default
 @return AZSignalErrorAlertModel instance
 */
FOUNDATION_EXPORT AZSignalErrorAlertModel * processErrorAlertModel(NSString *alertText,NSString *confirmTitle,dispatch_block_t confirmAction,NSString *cancelTitle,dispatch_block_t cancelAction);

@interface AZSignalErrorAlertModel : NSObject
@property (nonatomic, strong) NSString *alertText;
@property (nonatomic, strong) NSString *confirmTitle;
@property (nonatomic, copy) dispatch_block_t confirmAction;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, copy) dispatch_block_t cancelAction;
@end

@interface RACSignal<__covariant ValueType> (NSURLError)

// catch URLError and then send nil to next
- (RACSignal<ValueType> *)catchURLError;
- (RACSignal<ValueType> *)catchNSURLError;
- (RACSignal<ValueType> *)catchAzazieError;

- (RACSignal<ValueType> *)catchNSURLErrorCancelled;
- (RACSignal<ValueType> *)catchNSURLErrorNoResponse;

// zips the errors in the receiver with those of the given signal to create RACTuples or errors to send.
- (RACSignal *)zipErrorWith:(RACSignal *)signal;
+ (RACSignal<RACTuple *> *)zipErrors:(id<NSFastEnumeration>)signals;

// do URLError with customize alert, and then send an error.
- (RACSignal<ValueType> *)doURLErrorAlert;
- (RACSignal<ValueType> *)doNSURLErrorAlert;
- (RACSignal<ValueType> *)doAzazieURLErrorAlert;
- (RACSignal<ValueType> *)doURLErrorAlertWithConfirmTitle:(NSString *)title
                                                   action:(dispatch_block_t)action;
- (RACSignal<ValueType> *)doURLErrorAlertCustomize:(CustomizeErrorAlert)aBlock;
- (RACSignal<ValueType> *)doURLErrorAlertWithHead:(NSString *)head
                                     confirmTitle:(NSString *)title
                                    confirmAction:(dispatch_block_t)confirmAction
                                      cancelTitle:(NSString *)cancel
                                     cancelAction:(dispatch_block_t)cancelAction;

+ (void)showURLErrorAlertWith:(NSError *)error;
+ (void)showURLErrorAlertWith:(NSError *)error action:(dispatch_block_t)action;
+ (void)showAllURLErrorAlertWith:(NSError *)error;
+ (void)showAllURLErrorAlertWith:(NSError *)error action:(dispatch_block_t)action;
@end
