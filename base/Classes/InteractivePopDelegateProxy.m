//
//  InteractivePopDelegateProxy.m
//  base
//
//  Created by Demi on 29/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "InteractivePopDelegateProxy.h"

@implementation InteractivePopDelegateProxy

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.navigationController.navigationBarHidden && _navigationController.viewControllers.count > 1)
    {
        return YES;
    }
    else
    {
        if ([self.originalDelegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)])
        {
            return [self.originalDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
        }
        else
        {
            return YES;
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(gestureRecognizer:shouldReceiveTouch:))
    {
        return YES;
    }
    return [self.originalDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.originalDelegate;
}

@end
