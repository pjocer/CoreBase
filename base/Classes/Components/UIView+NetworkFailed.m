//
//  UIView+NetworkFailed.m
//  base
//
//  Created by Demi on 22/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "UIView+NetworkFailed.h"
#import <TXFire/TXFire.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@implementation UIView (NetworkFailed)

- (UIView *)base_viewForNetworkFailed
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)base_setViewForNetworkFailed:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(base_viewForNetworkFailed), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)addSubviewForNetworkFailed
{
    UIView *view = [self base_viewForNetworkFailed];
    if (!view)
    {
        view = [[UIView alloc] init];
        [self addSubview:view];
        [self base_setViewForNetworkFailed:view];
        view.backgroundColor = [UIColor tx_colorWithHex:0xf9f9f9];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Base" ofType:@"bundle"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_failed" inBundle:bundle compatibleWithTraitCollection:nil]];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.centerX.equalTo(view);
            maker.bottom.equalTo(view.mas_centerY).offset(-20.f);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        NSMutableParagraphStyle *mutableParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        mutableParagraphStyle.paragraphSpacing = 13.f;
        mutableParagraphStyle.alignment = NSTextAlignmentCenter;
        label.attributedText = [[NSMutableAttributedString alloc] initWithString:@"Oops, something's wrong here.\n Please tap screen to retry."
                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.f],
                                                                                   NSForegroundColorAttributeName: [UIColor tx_colorWithHex:0xcccccc],
                                                                                   NSParagraphStyleAttributeName: mutableParagraphStyle}];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.left.equalTo(view);
            maker.right.equalTo(view);
            maker.top.equalTo(view.mas_centerY).offset(17.f);
        }];
    }
    return view;
}

- (void)removeSubviewForNetworkFailed
{
    UIView *view = [self base_viewForNetworkFailed];
    if (view)
    {
        [self base_setViewForNetworkFailed:nil];
        [view removeFromSuperview];
    }
}

@end
