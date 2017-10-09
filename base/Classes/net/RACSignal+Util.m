//
//  RACSignal+Util.m
//  base
//
//  Created by Demi on 23/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+Util.h"
#import <TXFire/TXFire.h>
#import <libkern/OSAtomic.h>
#import <AZProgressHUD.h>

@implementation RACSignal (Util)

- (RACSignal *)hudWithView:(__weak UIView *)view
{
    @weakify(view);
    return [[self initially:^{
        @strongify(view);
        AZProgressHUD.showAzazieHUD.grace(0.5f);
    }] finally:^{
        @strongify(view);
        [AZProgressHUD hiddenAnimated:YES];
    }];
}

- (RACSignal *)hudWithViewController:(__weak UIViewController *)viewController
{
    return [self hudWithView:viewController.view];
}

- (RACSignal *)beforeDispose:(void(^)(void))block
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        __block volatile int32_t flag = 2;
        RACDisposable *disposable = [self subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            OSAtomicDecrement32(&flag);
            [subscriber sendError:error];
        } completed:^{
            OSAtomicDecrement32(&flag);
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            int32_t x = OSAtomicDecrement32(&flag);
            if (x != 0)
            {
                block();
            }
            [disposable dispose];
        }];
    }];
}



@end
