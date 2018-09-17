//
//  CustomNavigationBarViewController.m
//  mobile
//
//  Created by Demi on 13/03/2017.
//  Copyright © 2017 azazie. All rights reserved.
//

#import "CustomNavigationBarViewController.h"
#import <TXFire/TXFire.h>
#import "util.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "sys/utsname.h"
#import <Masonry/Masonry.h>

@interface CustomNavigationBarViewController () <UINavigationBarDelegate>

@end

@implementation CustomNavigationBarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self cnb_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self cnb_commonInit];
    }
    return self;
}

- (void)cnb_commonInit
{
    /// 因为可能在viewDidLoad之前设置左上角的back按钮，所以先初始化navigationBar和pushNavigationItem.
    _navigationBar = [[UINavigationBar alloc] init];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [_navigationBar pushNavigationItem:navigationItem animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _navigationBar.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:self.navigationBar];
    self.tx_interactiveNavigationBarHidden = YES;
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44.f);
    }];
}
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)) {
        [_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.safeAreaInsets.top);
        }];
    }
}
- (void)backlizeLeftBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:BaseImageWithNamed(@"nav_back") style:UIBarButtonItemStylePlain target:nil action:nil];
    @weakify(self);
    item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self back];
        return RACSignal.empty;
    }];
    self.navigationBar.topItem.leftBarButtonItem = item;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (BOOL)iPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *version = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([version isEqualToString:@"iPhone10,3"]) return YES;
    if ([version isEqualToString:@"iPhone10,6"]) return YES;
//    if ([version isEqualToString:@"x86_64"]) return YES;
    return NO;
}

@end
