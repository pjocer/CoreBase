//
//  AppIdentifier.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "AppIdentifier.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

@implementation AppIdentifier

+ (NSString *)IDFA
{
    NSUUID *UUID = [ASIdentifierManager sharedManager].advertisingIdentifier;
    return UUID ? UUID.UUIDString : @"";
}

+ (NSString *)IDFV
{
    NSUUID *UUID = [[UIDevice currentDevice] identifierForVendor];
    return UUID ? UUID.UUIDString : @"";
}

@end
