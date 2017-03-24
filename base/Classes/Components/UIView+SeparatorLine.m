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

static void *kSeparatorLinePosition = &kSeparatorLinePosition;

@implementation UIView (SeparatorLine)

- (const void *)seperator_keyForPosition:(TXViewPosition)pos
{
    static void *kTop = &kTop;
    static void *kLeft = &kLeft;
    static void *kBottom = &kBottom;
    static void *kRight = &kRight;
    
    if (pos == TXViewPositionTop)
    {
        return kTop;
    }
    else if (pos == TXViewPositionLeft)
    {
        return kLeft;
    }
    else if (pos == TXViewPositionRight)
    {
        return kRight;
    }
    else
    {
        return kBottom;
    }
}

- (UIView *)seperator_lineAtPosition:(TXViewPosition)pos
{
    return objc_getAssociatedObject(self, [self seperator_keyForPosition:pos]);
}

- (void)setSeparatorLine:(UIView *)line atPosition:(TXViewPosition)pos
{
    objc_setAssociatedObject(self, [self seperator_keyForPosition:pos], line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TXViewPosition)separatorLinePosition
{
    return [objc_getAssociatedObject(self, kSeparatorLinePosition) integerValue];
}

- (void)setSeparatorLinePosition:(TXViewPosition)separatorLinePosition
{
    objc_setAssociatedObject(self, kSeparatorLinePosition, @(separatorLinePosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    TXViewPosition posArray[4];
    posArray[0] = TXViewPositionTop;
    posArray[1] = TXViewPositionLeft;
    posArray[2] = TXViewPositionBottom;
    posArray[3] = TXViewPositionRight;
    
    for (NSInteger i = 0; i < 4; i++)
    {
        TXViewPosition pos = posArray[i];
        UIView *line = [self seperator_lineAtPosition:pos];
        if (pos & separatorLinePosition)
        {
            if (!line) // add separator line
            {
                UIView *line = [[UIView alloc] init].tx_backgroundColorHex(0xe1e1e1);
                [self addSubview:line];
                [self setSeparatorLine:line atPosition:pos];
                [line mas_makeConstraints:^(MASConstraintMaker *maker){
                    if (pos == TXViewPositionTop || pos == TXViewPositionBottom)
                    {
                        maker.left.and.right.equalTo(self);
                        maker.height.mas_equalTo(1.f);
                        if (pos == TXViewPositionTop)
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
                        maker.width.mas_equalTo(1.f);
                        if (pos == TXViewPositionLeft)
                        {
                            maker.left.equalTo(self);
                        }
                        else
                        {
                            maker.right.equalTo(self);
                        }
                    }
                }];
            }
        }
        else
        {
            if (line) // remove separator line
            {
                [line removeFromSuperview];
            }
        }
    }
}

@end
