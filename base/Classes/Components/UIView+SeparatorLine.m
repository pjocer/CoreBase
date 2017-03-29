//
//  UIView+SeparatorLine.m
//  base
//
//  Created by Demi on 24/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIView+SeparatorLine.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>

static void const *kTop = &kTop;
static void const *kLeft = &kLeft;
static void const *kBottom = &kBottom;
static void const *kRight = &kRight;

@implementation UIView (SeparatorLine)

- (const void *)separatorLineKeyForPosition:(UIRectEdge)pos
{
    if (pos == UIRectEdgeTop)
        return kTop;
    else if (pos == UIRectEdgeLeft)
        return kLeft;
    else if (pos == UIRectEdgeBottom)
        return kBottom;
    else if (pos == UIRectEdgeRight)
        return kRight;
    return NULL;
}

- (void)drawSeparatorLineToPosition:(UIRectEdge)target lineWidth:(CGFloat)lineWidth
{
    UIRectEdge positions[4];
    positions[0] = UIRectEdgeTop;
    positions[1] = UIRectEdgeLeft;
    positions[2] = UIRectEdgeBottom;
    positions[3] = UIRectEdgeRight;
    
    for (int i = 0; i < 4; i++)
    {
        UIRectEdge pos = positions[i];
        const void *keyForView = [self separatorLineKeyForPosition:pos];
        UIView *line = objc_getAssociatedObject(self, keyForView);
        if ((pos & target) == 0)
        {
            if (line)
            {
                [line removeFromSuperview];
                objc_setAssociatedObject(self, keyForView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            continue;
        }
        line = [[UIView alloc] init].tx_backgroundColorHex(0xe1e1e1);
        [self addSubview:line];
        objc_setAssociatedObject(self, keyForView, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [line mas_makeConstraints:^(MASConstraintMaker *maker){
            if (pos == UIRectEdgeTop || pos == UIRectEdgeBottom)
            {
                maker.leading.and.trailing.equalTo(self);
                maker.height.mas_equalTo(lineWidth);
                if (pos == UIRectEdgeTop)
                {
                    maker.top.equalTo(self);
                }
                else
                {
                    maker.bottom.equalTo(self);
                }
            }
            else
            {
                maker.top.and.bottom.equalTo(self);
                maker.width.mas_equalTo(lineWidth);
                if (pos == UIRectEdgeLeft)
                {
                    maker.leading.equalTo(self);
                }
                else
                {
                    maker.trailing.equalTo(self);
                }
            }
        }];
    }
}

- (void)drawSeparatorLineToPosition:(UIRectEdge)pos
{
    [self drawSeparatorLineToPosition:pos lineWidth:ONE_PIXEL];
}

@end
