//
//  util.m
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "util.h"

NSString * BasePathForResource(NSString *name, NSString *ext)
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Base" ofType:@"bundle"]];
    return [bundle pathForResource:name ofType:ext];
}
