//
//  BaseRouterHandler.h
//  base
//
//  Created by Jocer on 2018/6/12.
//  Copyright © 2018年 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "base.h"

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^BaseRouterCase)(RouterRequest *request, NSArray<NSString *> *_Nullable matchedResults);

@interface BaseRouterHandler : NSObject <RouterHandler>

/**
 Base RouterHandler which allow register patterns and cases between different frameworks.

 @param pattern An regular expression
 @param aCase aCase for this regular expression
 */
- (void)registerPattern:(NSString *)pattern case:(BaseRouterCase)aCase;
@end

NS_ASSUME_NONNULL_END
