//
//  RACSignal+ResponseToJSONModel.m
//  base
//
//  Created by Demi on 25/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "RACSignal+ResponseToJSONModel.h"
#import <JSONModel/JSONModel.h>

NSError * ResponseToJSONModelError(void)
{
    return [JSONModelError errorInvalidDataWithMessage:@"Cann't convert to JSONModel"];
}

@implementation RACSignal (ResponseToJSONModel)

- (RACSignal *)tryMapResponseToJSONModel:(Class)model
{
    NSCParameterAssert([model isSubclassOfClass:[JSONModel class]]);
    
    return [self tryMap:^id _Nonnull(RACTuple * _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        id result = [[model alloc] initWithDictionary:value.second error:NULL];
        if (result)
        {
            return result;
        }
        else
        {
            *errorPtr = ResponseToJSONModelError();
            return nil;
        }
    }];
}

- (RACSignal *)tryMapResponseToJSONModelArray:(Class)model
{
    NSCParameterAssert([model isSubclassOfClass:[JSONModel class]]);
    
    return [self tryMap:^id _Nonnull(RACTuple * _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        if ([value.second isKindOfClass:[NSArray class]])
        {
            NSArray *result = [model arrayOfModelsFromDictionaries:value.second error:NULL];
            if (result)
            {
                return result;
            }
        }
        
        *errorPtr = ResponseToJSONModelError();
        return nil;
    }];
}

@end
