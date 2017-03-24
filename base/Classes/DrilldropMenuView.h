//
//  DrilldropMenuView.h
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DrilldropMenuItem.h"
#import <ReactiveObjC/ReactiveObjC.h>

UIKIT_EXTERN const CGFloat DrilldropMenuViewExpectedHeight;

@interface DrilldropMenuView : UIView

@property (nonatomic, copy) NSArray<DrilldropMenuItem *> *items;

- (void)dismissDrilldropWithAnimated:(BOOL)aniamted;

@end
