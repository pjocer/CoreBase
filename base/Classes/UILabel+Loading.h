//
//  UILabel+Loading.h
//  AFNetworking
//
//  Created by Jocer on 2018/7/23.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager+BaseRACSupports.h"

@interface UILabel (Loading)
- (void)az_setTextWithSignal:(RACSignal <NSString *>*)aSignal
            expectedWidth:(CGFloat)width
                    color:(UIColor *)color;
- (void)az_setTextWithSignal:(RACSignal <NSString *>*)aSignal
               expectedWidth:(CGFloat)width
                   alignment:(NSTextAlignment)alignment
                       color:(UIColor *)color;
@end
