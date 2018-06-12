//
//  BaseRouterHandler.m
//  base
//
//  Created by Jocer on 2018/6/12.
//  Copyright © 2018年 Azazie. All rights reserved.
//

#import "BaseRouterHandler.h"

@interface BaseRouterHandler ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, BaseRouterCase> *cases;
@end

@implementation BaseRouterHandler
- (instancetype)init {
    self = [super init];
    if (self) {
        _cases = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPattern:(NSString *)pattern case:(BaseRouterCase)aCase {
    @synchronized (self) {
        _cases[pattern] = [aCase copy];
    }
}
- (id)request:(RouterRequest *)request {
    @synchronized (self) {
        __block id result = nil;
        NSString *str = request.URL.absoluteString;
        if (str.length == 0) {
            return nil;
        }
        if (TXRegexMatch(@"^base://([A-Za-z_]+)$", request.URL.absoluteString)) {
            // parse url from native
            [_cases enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, BaseRouterCase  _Nonnull obj, BOOL * _Nonnull stop) {
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:key options:0 error:NULL];
                NSTextCheckingResult *checkingResult = [regex firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
                if (checkingResult) {
                    NSString *matchedString = [str substringWithRange:checkingResult.range];
                    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:checkingResult.numberOfRanges - 1];
                    for (NSUInteger idx = 1; idx < checkingResult.numberOfRanges; idx++) {
                        Dlogvars(NSStringFromRange([checkingResult rangeAtIndex:idx]));
                        [groups addObject:[matchedString substringWithRange:[checkingResult rangeAtIndex:idx]]];
                    }
                    result = obj(request, groups.count > 0 ? groups : nil);
                    if (result) {
                        *stop = YES;
                    }
                }
            }];
        }
        return result;
    }
}
@end
