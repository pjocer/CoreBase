//
//  NetworkFailedView.m
//  base
//
//  Created by Demi on 31/03/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "NetworkFailedView.h"
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>
#import "util.h"

@implementation NetworkFailedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Base" ofType:@"bundle"]];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IS_AZAZIE?@"network_failed":@"network_failed_loveprom@" inBundle:bundle compatibleWithTraitCollection:nil]];
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.and.right.and.top.equalTo(self);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    mutableParagraphStyle.paragraphSpacing = 13.f;
    mutableParagraphStyle.alignment = NSTextAlignmentCenter;
    label.attributedText = [[NSMutableAttributedString alloc] initWithString:IS_AZAZIE?@"Oops, something's wrong here.\n Please tap screen to retry.":@"It seems that something went wrong. Please tap screen to retry."
                                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.f],
                                                                               NSForegroundColorAttributeName: [UIColor tx_colorWithHex:0xcccccc],
                                                                               NSParagraphStyleAttributeName: mutableParagraphStyle}];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.and.right.and.bottom.equalTo(self);
        maker.top.equalTo(imageView.mas_bottom).offset(37.f);
    }];
}

@end
