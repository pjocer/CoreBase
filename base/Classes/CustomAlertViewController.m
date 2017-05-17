//
//  CustomAlertViewController.m
//  mobile
//
//  Created by Demi on 11/05/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "CustomAlertViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <TXFire/TXFire.h>
#import "util.h"

@interface CustomAlertViewController ()

@end

@implementation CustomAlertViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);

    /// 防止点击事件把contentView的点击事件覆盖
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds].tx_backgroundColor([[UIColor blackColor] colorWithAlphaComponent:0.6f]);
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [backgroundView.tx_tapGestureRecognizer.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * _Nullable x) {
        @strongify(self);
        CGPoint point = [x locationInView:self.contentView];
        if (![self.contentView pointInside:point withEvent:nil])
        {
            [self dismiss];
        }
    }];
    
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.center.equalTo(self.view);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[BaseImageWithNamed(@"alert_close") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    _closeButton = button;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.trailing.and.top.equalTo(_contentView);
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self dismiss];
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
