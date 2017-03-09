//
//  PagingViewController.m
//  base
//
//  Created by Demi on 07/03/2017.
//  Copyright © 2017 Taylor Tang. All rights reserved.
//

#import "PagingViewController.h"
#import "BasePagingView.h"
#import <TXFire/TXFire.h>
#import <Masonry/Masonry.h>
#import "AFHTTPSessionManager+BaseRACSupports.h"
#import "BaseTmpNetworkStorage.h"

@interface PagingViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *testHTTPManager;

@end

@implementation PagingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *content = @"abc";
    BOOL result = [BaseTmpNetworkStorage write:[content dataUsingEncoding:NSUTF8StringEncoding] toKey:@"test"];
    TXLog(@"%@", stringify_bool(result));
    
    _testHTTPManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:nil];
    _testHTTPManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[[_testHTTPManager rac_GET:@"https://m.baidu.com" parameters:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x){
         NSData *data = [(RACTuple *)x second];
         TXLog(@"%@", data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]: @"empty");
     }
     error:^(NSError *error){
         TXLog(@"%@", error);
     }
     completed:^{
         TXLog(@"%@", @"completed");
     }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    BasePagingView *view = [[BasePagingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    NSArray *pages = [@[@"1", @"2", @"3", @"4"] tx_map:^(NSString *text){
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.f
                                                green:(arc4random() % 256) / 255.f
                                                 blue:(arc4random() % 256) / 255.f
                                                alpha:1.f];
        return label;
    }];
    
    [view addPages:pages];
}

@end
