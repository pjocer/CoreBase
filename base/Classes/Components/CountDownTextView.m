//
//  CountDownTextView.m
//  mobile
//
//  Created by Jocer on 2018/6/20.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import "CountDownTextView.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>

@interface CountDownTextView()
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation CountDownTextView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor qmui_colorWithHexString:@"#333333"];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.countDownView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.left.mas_greaterThanOrEqualTo(10).priorityLow();
            make.right.bottom.mas_lessThanOrEqualTo(-10).priorityLow();
        }];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
        }];
        [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.descriptionLabel.mas_right).offset(3);
        }];
    }
    return self;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(10) textColor:UIColorWhite];
        _descriptionLabel.text = @"10% OFF FOR ALL WEDDING DRESSES ENDS IN";
    }
    return _descriptionLabel ;
}
- (CountDownView *)countDownView {
    if (!_countDownView) {
        _countDownView = [[CountDownView alloc] init];
        _countDownView.translatesAutoresizingMaskIntoConstraints = NO;
        _countDownView.textFont = UIFontBoldMake(13);
        _countDownView.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
        _countDownView.recoderTimeIntervalDidInBackground = YES;
        _countDownView.colonColor = UIColorWhite;
        _countDownView.backgroundImage = UIImageMake(@"count_down");
    }
    return _countDownView;
}
@end
