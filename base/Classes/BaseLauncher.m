//
//  BaseLauncher.m
//  base
//
//  Created by Demi on 23/05/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "BaseLauncher.h"
#import <UIKit/UIKit.h>
#import "ProfileAutoLoader.h"

@implementation BaseLauncher

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)didFinishLaunching:(NSNotification *)note
{
    [ProfileAutoLoader sharedLoader]; // start profile auto loader.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
