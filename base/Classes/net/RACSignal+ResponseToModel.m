//
//  RACSignal+ResponseToJSONModel.m
//  base
//
//  Created by Demi on 25/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+ResponseToModel.h"
#import <YYModel/YYModel.h>

NSError * ResponseToJSONModelError(void) {
    return [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:nil];
}

@implementation RACSignal (ResponseToModel)

- (RACSignal *)tryMapResponseToModel:(Class)model {
    
    return [self tryMap:^id _Nonnull(RACTuple * _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        id result = [model yy_modelWithDictionary:value.second];
        if (result) {
            return result;
        } else {
            *errorPtr = ResponseToJSONModelError();
            return nil;
        }
    }];
}

- (RACSignal *)tryMapResponseToModelArray:(Class)model {
    return [self tryMap:^id _Nonnull(RACTuple * _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        if ([value.second isKindOfClass:[NSArray class]]) {
            NSArray *result = [NSArray yy_modelArrayWithClass:model json:value.second];
            if (result) {
                return result;
            }
        }
        *errorPtr = ResponseToJSONModelError();
        return nil;
    }];
}

@end
