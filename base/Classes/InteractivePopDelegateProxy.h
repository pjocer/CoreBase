//
//  InteractivePopDelegateProxy.h
//  base
//
//  Created by Demi on 29/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InteractivePopDelegateProxy : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> originalDelegate;
@property (nonatomic, weak) UINavigationController *navigationController;

@end
