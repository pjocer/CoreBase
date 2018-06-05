//
//  RACSignal+NSURLError.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+NSURLError.h"
#import "AZAlert.h"
#import <TXFire/TXFire.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/RACStream+Private.h>

NSErrorDomain const AzazieErrorDomain = @"kAzazieErrorDomain";
NSString *const AzazieErrorDomainErrorsKey = @"AzazieErrorDomainErrorsKey";
NSString *const AzazieErrorSingleErrorMessageKey = @"AzazieErrorSingleErrorMessageKey";

NSInteger const AzazieErrorMultipleErrors = -5000;
NSInteger const AzazieErrorSingleError = -5001;

static void notifyDataNotAllowed(void) {
    AZAlert *alert = [AZAlert alertWithTitle:@"DataNotAllowed" detailText:nil preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"Settings" action:^{
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:NULL];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }];
    [alert addCancelItemWithTitle:@"Cancel" action:NULL];
    [alert show];
}

@implementation RACSignal (NSURLError)

+ (NSString *)__NSURLErrorMessageWithCode:(NSInteger)code {
    NSString *msg = nil;
    if (code == NSURLErrorNotConnectedToInternet) {
        msg = @"The internet connection appears to be offline.";
    } else if (code == NSURLErrorTimedOut) {
        msg = @"The request timeout. Please try again.";
    } else {
        msg = @"Unable to connect to server. Please try again.";
    }
    return msg;
}

+ (NSString *)__AzazieURLErrorMessageWithError:(NSError *)error {
    if (error.HTTPResponse && error.errorMessageByServer) {
        return error.errorMessageByServer;
    }
    if (error.code == AzazieErrorSingleError) {
        return error.userInfo[AzazieErrorSingleErrorMessageKey];
    }
    return nil;
}

+ (void)__doNSURLErrorWithCode:(NSInteger)code title:(NSString *)title action:(dispatch_block_t)action {
    if (code == NSURLErrorCancelled) {
        return;
    }
    if (code == NSURLErrorDataNotAllowed) {
        notifyDataNotAllowed();
        return;
    }
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:[RACSignal __NSURLErrorMessageWithCode:code] preferConfirm:YES];
    [alert addConfirmItemWithTitle:title action:action];
    [alert show];
}

+ (void)__doAzazieURLErrorWithError:(NSError *)error
                               Head:(NSString *)head
                       confirmTitle:(NSString *)confirmTitle
                      confirmAction:(dispatch_block_t)confirmAction
                        cancelTitle:(NSString *)cancelTitle
                       cancelAction:(dispatch_block_t)cancelAction {
    dispatch_block_t _confirmAction = confirmAction;
    NSString *_confirmTitle = confirmTitle;
    dispatch_block_t _cancelAction = cancelAction;
    NSString *_cancelTitle = cancelTitle;
    NSString *_head = head;
    NSMutableArray *detailTexts = [NSMutableArray arrayWithCapacity:0];
    if (error.errorMessageByServer) {
        [detailTexts addObject:error.errorMessageByServer];
    }
    if (error.domain == AzazieErrorDomain) {
        if (error.code == AzazieErrorMultipleErrors) {
            NSArray <NSError *>*errors = error.userInfo[AzazieErrorDomainErrorsKey];
            if (errors.count == 1) {
                NSString *msg = [RACSignal __AzazieURLErrorMessageWithError:errors[0]];
                if (!msg) {
                    _confirmAction = NULL;
                    _confirmTitle = @"OK";
                    _cancelAction = NULL;
                    _cancelTitle = nil;
                    msg = [RACSignal __NSURLErrorMessageWithCode:errors[0].code];
                }
                [detailTexts addObject:msg];
            } else {
                [errors enumerateObjectsUsingBlock:^(NSError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *msg = [RACSignal __AzazieURLErrorMessageWithError:obj]?:[RACSignal __NSURLErrorMessageWithCode:obj.code];
                    if (![detailTexts containsObject:msg]) [detailTexts addObject:msg];
                }];
            }
        }
        if (error.code == AzazieErrorSingleError) {
            [detailTexts addObject:error.userInfo[AzazieErrorSingleErrorMessageKey]];
        }
    }
    AZAlert *alert = [AZAlert alertWithTitle:_head detailTexts:detailTexts preferConfirm:YES];
    if (!_confirmTitle || _confirmTitle.length == 0) _confirmTitle = @"OK";
    [alert addConfirmItemWithTitle:_confirmTitle action:_confirmAction];
    if (_cancelTitle && _cancelTitle.length > 0) {
        [alert addCancelItemWithTitle:_cancelTitle action:_cancelAction];
    }
    [alert show];
}

- (RACSignal *)catchURLError {
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        return [RACSignal return:nil];
    }];
}
- (RACSignal *)catchAzazieError {
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        return [RACSignal if:[RACSignal return:@(error.responseObject!=nil)] then:[RACSignal return:nil] else:[RACSignal error:error]];
    }];
}

- (RACSignal *)catchAzazieInvalidTokenError {
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        return [RACSignal if:[RACSignal return:@(error.errorGlobalCodeByServer.integerValue == 10301)] then:RACSignal.empty else:[RACSignal error:error]];
    }];
}

- (RACSignal *)catchNSURLError {
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) {
            return [RACSignal error:error];
        }
        return [RACSignal return:nil];
    }];
}

- (RACSignal *)catchNSURLErrorCancelled {
    return [self catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
            return [RACSignal return:nil];
        } else {
            return [RACSignal error:error];
        }
    }];
}

- (RACSignal *)catchNSURLErrorNoResponse {
    return [[self catchNSURLErrorCancelled] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        NSHTTPURLResponse *response = error.HTTPResponse;
        if (!response) {
            NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
            response = underlyingError.HTTPResponse;
        }
        if ((response && response.statusCode == 404)||(error.isResponseSerializationError && error.code == NSURLErrorBadServerResponse)) {
            return [RACSignal return:nil];
        }
        return [RACSignal error:error];
    }];
}

+ (RACSignal<RACTuple *> *)zipErrors:(id<NSFastEnumeration>)signals {
    return [[self join:signals block:^(RACSignal *left, RACSignal *right) {
        return [left zipErrorWith:right];
    }] setNameWithFormat:@"+zipErrors: %@", signals];
}

- (RACSignal *)zipErrorWith:(RACSignal *)signal {
    NSCParameterAssert(signal != nil);
    return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        __block BOOL selfCompleted = NO;
        __block NSError *selfError = nil;
        NSMutableArray *selfValues = [NSMutableArray array];
        
        __block BOOL otherCompleted = NO;
        __block NSError *otherError = nil;
        NSMutableArray *otherValues = [NSMutableArray array];
        __block RACTuple *tuple = nil;
        
        void (^sendCompletedIfNecessary)(void) = ^{
            @synchronized (selfValues, otherValues) {
                BOOL selfEmpty = (selfCompleted && selfValues.count == 0);
                BOOL otherEmpty = (otherCompleted && otherValues.count == 0);
                if (selfEmpty || otherEmpty) [subscriber sendCompleted];
            }
        };
        void (^sendErrorIfNecessary)(void) = ^ {
            @synchronized(selfError, otherError) {
                BOOL selfErrorAlready = (selfError!=nil || selfCompleted);
                BOOL otherErrorAlready = (otherError!=nil || otherCompleted);
                if (!(selfErrorAlready && otherErrorAlready)) return ;
                
                NSMutableArray <NSError *>* __block errors = [NSMutableArray arrayWithCapacity:0];
                [[RACScheduler immediateScheduler] scheduleRecursiveBlock:^(void (^ _Nonnull reschedule)(void)) {
                    if (otherError) {
                        [errors addObject:otherError];
                    }
                    if (selfError) {
                        if (selfError.domain == AzazieErrorDomain) {
                            if (selfError.code == AzazieErrorMultipleErrors) {
                                NSArray *inErrors = selfError.userInfo[AzazieErrorDomainErrorsKey];
                                if (inErrors.count!=0) {
                                    if (inErrors.count == 1) {
                                        selfError = inErrors[0];
                                        otherError = nil;
                                    } else if (inErrors.count == 2) {
                                        selfError = inErrors[0];
                                        otherError = inErrors[1];
                                    } else {
                                        otherError = inErrors.lastObject;
                                        inErrors = [inErrors subarrayWithRange:NSMakeRange(0, inErrors.count-1)];
                                        NSDictionary *userInfo = @{AzazieErrorDomainErrorsKey:inErrors};
                                        selfError = [NSError errorWithDomain:AzazieErrorDomain code:AzazieErrorMultipleErrors userInfo:userInfo];
                                    }
                                    reschedule();
                                }
                            } else if (selfError.code == AzazieErrorSingleError) {
                                [errors addObject:selfError];
                            }
                        } else {
                            if (errors.count > 0) {
                                NSMutableArray <NSError *>*temp = [NSMutableArray arrayWithArray:errors];
                                [errors enumerateObjectsUsingBlock:^(NSError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if (obj.responseObject || obj.domain == AzazieErrorDomain) {
                                        [temp addObject:selfError];
                                    } else {
                                        *stop = YES;
                                    }
                                }];
                                errors = temp;
                            } else {
                                [errors addObject:selfError];
                            }
                        }
                    }
                }];
                NSDictionary *userInfo = @{AzazieErrorDomainErrorsKey:errors};
                NSError *error = [NSError errorWithDomain:AzazieErrorDomain code:AzazieErrorMultipleErrors userInfo:userInfo];
                [subscriber sendError:error];
            }
        };
        void (^sendNext)(void) = ^{
            @synchronized (selfValues, otherValues) {
                if (selfValues.count == 0 || otherValues.count == 0) return;
                RACTuple *tuple = RACTuplePack(selfValues[0], otherValues[0]);
                [selfValues removeObjectAtIndex:0];
                [otherValues removeObjectAtIndex:0];
                [subscriber sendNext:tuple];
                sendCompletedIfNecessary();
            }
        };
        
        RACDisposable *selfDisposable = [self subscribeNext:^(id x) {
            @synchronized (selfValues) {
                [selfValues addObject:x ?: RACTupleNil.tupleNil];
                sendNext();
            }
        } error:^(NSError *error) {
            @synchronized (selfError) {
                selfError = error;
                sendErrorIfNecessary();
            }
        } completed:^{
            @synchronized (selfValues) {
                selfCompleted = YES;
                sendCompletedIfNecessary();
                sendErrorIfNecessary();
            }
        }];
        RACDisposable *otherDisposable = [signal subscribeNext:^(id x) {
            @synchronized (otherValues) {
                [otherValues addObject:x ?: RACTupleNil.tupleNil];
                sendNext();
            }
        } error:^(NSError *error) {
            @synchronized (otherError) {
                otherError = error;
                sendErrorIfNecessary();
            }
        } completed:^{
            @synchronized (selfValues) {
                otherCompleted = YES;
                sendCompletedIfNecessary();
                sendErrorIfNecessary();
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [selfDisposable dispose];
            [otherDisposable dispose];
        }];
    }] setNameWithFormat:@"[%@] -zipErrorWith: %@", self.name, signal];
}

- (RACSignal *)doURLErrorAlert {
    return [self doURLErrorAlertWithConfirmTitle:@"OK" action:NULL];
}

- (RACSignal *)doNSURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) return ;
        [RACSignal __doNSURLErrorWithCode:error.code title:@"OK" action:NULL];
    }];
}

- (RACSignal *)doAzazieURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) {
            if (error.errorCodeByServer.integerValue != 10301) {
                [RACSignal __doAzazieURLErrorWithError:error Head:nil confirmTitle:nil confirmAction:NULL cancelTitle:nil cancelAction:NULL];
            }
        }
    }];
}
- (RACSignal *)doInvalidTokenURLErrorAlertAction:(AFHTTPSessionManager *)manager {
    @weakify(manager)
    return [self doError:^(NSError * _Nonnull error) {
        @strongify(manager);
        if (error.responseObject && error.errorGlobalCodeByServer.integerValue == 10301) {
            if (manager.isGroupInvalidTokenAction) {
                if (manager.needHiddenInvalidTokenAlert) {
                    [manager handleInvalidToken];
                }
            } else {
                if (manager.needHiddenInvalidTokenAlert) {
                    [manager handleInvalidToken];
                } else {
                    [RACSignal __doAzazieURLErrorWithError:error Head:@"Hmmm..." confirmTitle:@"OK" confirmAction:^{
                        [manager handleInvalidToken];
                    } cancelTitle:nil cancelAction:NULL];
                }
            }
        }
    }];
}
- (RACSignal *)doURLErrorAlertWithConfirmTitle:(NSString *)title action:(dispatch_block_t)action {
    return [self doURLErrorAlertWithHead:nil confirmTitle:title confirmAction:action cancelTitle:nil cancelAction:NULL];
}

- (RACSignal *)doURLErrorAlertWithHead:(NSString *)head confirmTitle:(NSString *)title confirmAction:(dispatch_block_t)confirmAction cancelTitle:(NSString *)cancel cancelAction:(dispatch_block_t)cancelAction {
    return [self doError:^(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) {
            if (error.errorCodeByServer.integerValue != 10301) {
                [RACSignal __doAzazieURLErrorWithError:error Head:head confirmTitle:title confirmAction:confirmAction cancelTitle:cancel cancelAction:cancelAction];
            }
        } else {
            [RACSignal __doNSURLErrorWithCode:error.code title:title action:NULL];
        }
    }];
}

+ (void)showURLErrorAlertWith:(NSError *)error {
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:[RACSignal __NSURLErrorMessageWithCode:error.code] preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"OK" action:NULL];
    [alert show];
}

+ (void)showURLErrorAlertWith:(NSError *)error action:(dispatch_block_t)action {
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:[RACSignal __NSURLErrorMessageWithCode:error.code] preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"OK" action:action];
    [alert show];
}

@end
