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
#import <AFNetworking.h>
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

+ (void)__doNSURLErrorWithCode:(NSInteger)code {
    if (code == NSURLErrorCancelled) {
        return;
    }
    if (code == NSURLErrorDataNotAllowed) {
        notifyDataNotAllowed();
        return;
    }
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:[RACSignal __NSURLErrorMessageWithCode:code] preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"OK" action:NULL];
    [alert show];
}

+ (void)__doAzazieURLErrorWithError:(NSError *)error {
    NSMutableArray *detailTexts = [NSMutableArray arrayWithCapacity:0];
    if (error.HTTPResponse && error.errorMessageByServer) {
        [detailTexts addObject:error.errorMessageByServer];
    }
    if (error.domain == AzazieErrorDomain) {
        if (error.code == AzazieErrorMultipleErrors) {
            NSArray <NSError *>*errors = error.userInfo[AzazieErrorDomainErrorsKey];
            [errors enumerateObjectsUsingBlock:^(NSError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *msg = [RACSignal __AzazieURLErrorMessageWithError:obj]?:[RACSignal __NSURLErrorMessageWithCode:obj.code];
                if (![detailTexts containsObject:msg]) [detailTexts addObject:msg];
            }];
        }
        if (error.code == AzazieErrorSingleError) {
            [detailTexts addObject:error.userInfo[AzazieErrorSingleErrorMessageKey]];
        }
    }
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailTexts:detailTexts preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"OK" action:NULL];
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
                
                NSMutableArray <NSError *>*errors = [NSMutableArray arrayWithCapacity:0];
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
                            [errors enumerateObjectsUsingBlock:^(NSError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (obj.responseObject || obj.domain == AzazieErrorDomain) {
                                    [errors addObject:selfError];
                                } else {
                                    *stop = YES;
                                }
                            }];
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
    return [self doError:^(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) {
            [RACSignal __doAzazieURLErrorWithError:error];
        } else {
            [RACSignal __doNSURLErrorWithCode:error.code];
        }
    }];
}

- (RACSignal *)doNSURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        if (error.responseObject || error.domain == AzazieErrorDomain) return ;
        [RACSignal __doNSURLErrorWithCode:error.code];
    }];
}

- (RACSignal *)doAzazieURLErrorAlert {
    return [self doError:^(NSError * _Nonnull error) {
        [RACSignal __doAzazieURLErrorWithError:error];
    }];
}

+ (void)showURLErrorAlertWith:(NSError *)error {
    AZAlert *alert = [AZAlert alertWithTitle:@"Hmmm..." detailText:[RACSignal __NSURLErrorMessageWithCode:error.code] preferConfirm:YES];
    [alert addConfirmItemWithTitle:@"OK" action:NULL];
    [alert show];
}

@end
