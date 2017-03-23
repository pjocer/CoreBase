//
//  util.m
//  base
//
//  Created by Demi on 17/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "util.h"

static inline NSBundle *BaseBundle(void)
{
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Base" ofType:@"bundle"]];
}

NSString * BasePathForResource(NSString *name, NSString *ext)
{
    return [BaseBundle() pathForResource:name ofType:ext];
}

UIImage * BaseImageWithNamed(NSString *name)
{
    return [UIImage imageNamed:name inBundle:BaseBundle() compatibleWithTraitCollection:nil];
}


