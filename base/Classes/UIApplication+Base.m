//
//  UIApplication+Base.m
//  base
//
//  Created by Demi on 16/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIApplication+Base.h"
#import <pthread/pthread.h>

static NSInteger networkActivityCount = 0;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

@implementation UIApplication (Base)

- (void)showNetworkActivityIndicator
{
    pthread_mutex_lock(&mutex);
    {
        networkActivityCount += 1;
    }
    pthread_mutex_unlock(&mutex);
    self.networkActivityIndicatorVisible = YES;
}

- (void)hideNetworkActivityIndicator
{
    pthread_mutex_lock(&mutex);
    {
        if (networkActivityCount >= 1)
        {
            networkActivityCount -= 1;
        }
    }
    pthread_mutex_unlock(&mutex);
    if (networkActivityCount == 0)
    {
        self.networkActivityIndicatorVisible = NO;
    }
}

@end
