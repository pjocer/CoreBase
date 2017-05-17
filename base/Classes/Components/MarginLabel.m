//
//  MarginLabel.m
//  AzazieObjcDemo
//
//  Created by Demi on 2017/01/17.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "MarginLabel.h"

@implementation MarginLabel

- (void)setMarginInset:(UIEdgeInsets)marginInset
{
    _marginInset = marginInset;
    [self setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden
{
    if (self.hidden != hidden)
    {
        [super setHidden:hidden];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setSuppressesZeroSizeOnHidden:(BOOL)suppressesZeroSizeOnHidden
{
    if (_suppressesZeroSizeOnHidden != suppressesZeroSizeOnHidden)
    {
        _suppressesZeroSizeOnHidden = suppressesZeroSizeOnHidden;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)drawTextInRect:(CGRect)rect
{
    rect.origin.x += _marginInset.left;
    rect.origin.y += _marginInset.top;
    
    rect.size.width -= (_marginInset.left + _marginInset.right);
    rect.size.height -= (_marginInset.top + _marginInset.bottom);
    
    [super drawTextInRect:rect];
}

- (CGSize)intrinsicContentSize
{
    if (!self.hidden || _suppressesZeroSizeOnHidden)
    {
        CGSize size = [super intrinsicContentSize];
        size.width += (_marginInset.left + _marginInset.right);
        size.height += (_marginInset.top + _marginInset.bottom);
        return size;
    }
    else
    {
        return CGSizeZero;
    }
}

- (__kindof MarginLabel *(^)(UIEdgeInsets))tx_marginInset
{
    return ^(UIEdgeInsets v){
        self.marginInset = v;
        return self;
    };
}

- (__kindof MarginLabel *(^)(BOOL))tx_suppressesZeroSizeOnHidden
{
    return ^(BOOL v){
        self.suppressesZeroSizeOnHidden = v;
        return self;
    };
}

@end
