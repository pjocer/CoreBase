//
//  RACSignal+ResponseToJSONModel.h
//  base
//
//  Created by Demi on 25/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

FOUNDATION_EXTERN NSError * ResponseToJSONModelError(void);

@interface RACSignal (ResponseToJSONModel)

/// must be subclass of JSONModel
- (RACSignal *)tryMapResponseToJSONModel:(Class)model;
/// must be subclass of JSONModel
- (RACSignal *)tryMapResponseToJSONModelArray:(Class)model;

@end
