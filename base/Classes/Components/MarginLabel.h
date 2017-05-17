//
//  MarginLabel.h
//  AzazieObjcDemo
//
//  Created by Demi on 2017/01/17.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

/// if hidden, the intrinsicContentSize will be CGSizeZero
@interface MarginLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets marginInset;
@property (nonatomic, assign) BOOL suppressesZeroSizeOnHidden;

- (__kindof MarginLabel *(^)(UIEdgeInsets))tx_marginInset;
- (__kindof MarginLabel *(^)(BOOL))tx_suppressesZeroSizeOnHidden;

@end
