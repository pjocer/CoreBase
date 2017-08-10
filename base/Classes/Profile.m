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
#import <YYModel.h>

NSString *const ProfileDidChangeNotification = @"ProfileDidChangeNotification";
NSString *const ProfileChangeOldKey = @"ProfileChangeOldKey";
NSString *const ProfileChangeNewKey = @"ProfileChangeNewKey";

static NSString *const key = @"com.azaize.profile";
static Profile *globalProfile = nil;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static BOOL loadedFromDisk = NO;

@interface Profile ()

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy, nullable) NSString *user_name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger language_id;
@property (nonatomic, assign) NSInteger currency_id;
@property (nonatomic, copy) NSString *lang_code;
@property (nonatomic, assign) NSInteger shoppingCartGoodsTotal;

@end

@implementation Profile

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

+ (void)setCurrentProfile:(Profile *)profile {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    pthread_mutex_lock(&mutex); {
        Profile *oldProfile = globalProfile;
        Profile *newProfile = profile;
        
        if (!oldProfile && !newProfile) {
            pthread_mutex_unlock(&mutex);
            return;
        }
        
        if (oldProfile) {
            userInfo[ProfileChangeOldKey] = oldProfile;
        }
        if (newProfile) {
            userInfo[ProfileChangeNewKey] = newProfile;
        }
        
        if (newProfile) {
            if (oldProfile && ![oldProfile yy_modelIsEqual:newProfile]) {
                globalProfile = newProfile.copy;
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newProfile];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:encodedObject forKey:key];
                [defaults synchronize];
            }  
        } else {
            globalProfile = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    pthread_mutex_unlock(&mutex);
    if (NSThread.isMainThread || NSOperationQueue.mainQueue == NSOperationQueue.currentQueue) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ProfileDidChangeNotification object:nil userInfo:userInfo];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ProfileDidChangeNotification object:nil userInfo:userInfo];
        });
    }
}

@end
