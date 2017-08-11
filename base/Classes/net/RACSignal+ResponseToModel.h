//
//  RACSignal+ResponseToModel.h
//  base
//
//  Created by Demi on 25/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

FOUNDATION_EXTERN NSError * ResponseToModelError(void);

@interface RACSignal (ResponseToModel)

- (RACSignal *)tryMapResponseToModel:(Class)model;

- (RACSignal *)tryMapResponseToModelArray:(Class)model;

@end
