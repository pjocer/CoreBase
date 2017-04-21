//
//  Profile.m
//  base
//
//  Created by Demi on 21/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "Profile.h"
#import <pthread/pthread.h>
#import "Network.h"

NSString *const ProfileDidChangeNotification = @"ProfileDidChangeNotification";
NSString *const ProfileChangeOldKey = @"ProfileChangeOldKey";
NSString *const ProfileChangeNewKey = @"ProfileChangeNewKey";

static NSString *const key = @"com.azaize.profile";
static Profile *globalProfile = nil;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static BOOL loadedFromDisk = NO;

@interface Profile ()

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger languageID;
@property (nonatomic, assign) NSInteger currencyID;
@property (nonatomic, copy) NSString *langCode;
@property (nonatomic, assign) NSInteger preLoginShoppingCartGoodsTotal;
@property (nonatomic, assign) NSInteger shoppingCartGoodsTotal;

@end

@implementation Profile

+ (RACSignal<Profile *> *)loadProfile
{
    Profile *profile = [self currentProfile];
    if (profile)
    {
        return [RACSignal return:profile];
    }
    
    return [[[Network.APISession rac_GET:@"me" parameters:nil] tryMap:^id _Nonnull(RACTuple * _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        NSDictionary *responseObject = value.second;
        Profile *profile = [[Profile alloc] initWithDictionary:responseObject error:nil];
        if (!profile && errorPtr)
        {
            *errorPtr = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotParseResponse userInfo:@{NSLocalizedDescriptionKey: @"cann't parse response"}];
        }
        return profile;
    }] doNext:^(Profile * _Nullable x) {
        [Profile setCurrentProfile:x];
    }];
}

+ (nullable Profile *)currentProfile
{
    pthread_mutex_lock(&mutex);
    {
        if (!loadedFromDisk)
        {
            loadedFromDisk = YES;
            NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (encodedObject)
            {
                globalProfile = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            }
        }
    }
    pthread_mutex_unlock(&mutex);
    return globalProfile;
}

+ (void)setCurrentProfile:(Profile *)profile
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    pthread_mutex_lock(&mutex);
    {
        Profile *oldProfile = globalProfile;
        Profile *newProfile = profile;
        
        if (!oldProfile && !newProfile)
        {
            pthread_mutex_unlock(&mutex);
            return;
        }
        
        if (oldProfile)
        {
            userInfo[ProfileChangeOldKey] = oldProfile;
        }
        if (newProfile)
        {
            userInfo[ProfileChangeNewKey] = newProfile;
        }
        
        if (newProfile)
        {
            globalProfile = newProfile.copy;
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newProfile];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:encodedObject forKey:key];
            [defaults synchronize];
        }
        else
        {
            globalProfile = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    pthread_mutex_unlock(&mutex);
    
    if (NSThread.isMainThread || NSOperationQueue.mainQueue == NSOperationQueue.currentQueue)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProfileDidChangeNotification object:nil userInfo:userInfo];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ProfileDidChangeNotification object:nil userInfo:userInfo];
        });
    }
}

@end
