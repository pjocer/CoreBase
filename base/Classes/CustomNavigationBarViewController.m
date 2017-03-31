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

@interface CustomNavigationBarViewController ()

@end

@implementation CustomNavigationBarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tx_interactiveNavigationBarHidden = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.tx_interactiveNavigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64.f)];
    [self.view addSubview:navigationBar];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    _navigationBar = navigationBar;
}

- (void)backlizeLeftBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:BaseImageWithNamed(@"nav_back") style:UIBarButtonItemStylePlain target:nil action:nil];
    @weakify(self);
    item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        return RACSignal.empty;
    }];
    self.navigationBar.topItem.leftBarButtonItem = item;
}

@end
