//
//  ProfileAutoLoader.m
//  base
//
//  Created by Demi on 22/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "ProfileAutoLoader.h"
#import "AccessToken.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "Profile.h"
#import "Network.h"
#import <YYModel/YYModel.h>
#import "RACSignal+ResponseToModel.h"

@interface ProfileAutoLoader ()

@property (nonatomic, strong) RACScopedDisposable *disposable;

@end

@implementation ProfileAutoLoader

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        Profile *profile = [Profile currentProfile];
        if (!profile)
        {
            if ([AccessToken currentAccessToken])
            {
                [self requestProfileUntilSuccess];
            }
        }
        [self prepare];
    }
    return self;
}

+ (ProfileAutoLoader *)sharedLoader
{
    static ProfileAutoLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[ProfileAutoLoader alloc] initPrivate];
    });
    return loader;
}

- (void)prepare
{
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccessTokenDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        AccessToken *token = x.userInfo[AccessTokenChangeNewKey];
        self.disposable = nil;
        if (token)
        {
            [self requestProfileUntilSuccess];
        }
    }];
}

- (void)requestProfileUntilSuccess
{
    @weakify(self);
    self.disposable = [[[[Network.APISession rac_GET:@"me" parameters:nil] tryMapResponseToModel:Profile.class] doNext:^(Profile * _Nullable x) {
        [Profile setCurrentProfile:x];
    }] subscribeError:^(NSError * _Nullable error) {
        if ([AccessToken currentAccessToken])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self requestProfileUntilSuccess];
            });
        }
    }].asScopedDisposable;
}

@end
