//
//  BaseTableViewCell.m
//  UCaiYuan
//
//  Created by wanyakun on 15/9/8.
//  Copyright (c) 2015年 com.ucaiyuan. All rights reserved.

#import "BaseTableViewCell.h"


@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *) reuseIdentifier {
    return [[self class] description];
}

@end
