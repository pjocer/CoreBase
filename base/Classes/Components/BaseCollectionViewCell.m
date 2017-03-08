//
//  BaseCollectionViewCell.m
//  UCaiYuan
//
//  Created by wanyakun on 15/9/24.
//  Copyright © 2015年 com.ucaiyuan. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSString *nibName = NSStringFromClass([self class]);
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
        if (nibPath) {
            NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            //如果xib的第一个view存在，并且是UICollectionViewCell类或者子类，返回第一个view
            if (arrayOfViews.count > 0 && [[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
                self = [arrayOfViews objectAtIndex:0];
            }
        }
    }
    return self;
}

- (NSString *)reuseIdentifier {
    return [[self class] description];
}

@end
