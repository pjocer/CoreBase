//
//  UserAgent.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UserAgent.h"
#import <UIKit/UIKit.h>
#import <TXFire/TXFire.h>

@implementation UserAgent

+ (NSString *)retrieveUserAgentInWebview
{
    static NSString *userAgent = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    });
    return userAgent;
}

+ (NSString *)defaultUserAgent
{
    return [self retrieveUserAgentInWebview];
}

+ (NSString *)customUserAgent
{
    NSString *userAgent = [self retrieveUserAgentInWebview];
    NSString *app = [[[[[NSBundle mainBundle] bundleIdentifier] componentsSeparatedByString:@"."] objectAtIndex:1] capitalizedString];
    return [NSString stringWithFormat:@"%@ %@/%@", userAgent, app, [UIApplication sharedApplication].tx_appVersion];
}

@end
