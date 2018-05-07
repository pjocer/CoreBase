//
//  Profile.m
//  base
//
//  Created by Jocer on 21/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "Profile.h"
#import <pthread/pthread.h>
#import "Network.h"
#import <NSObject+YYModel.h>

NSString *const ProfileDidChangeNotification = @"ProfileDidChangeNotification";
NSString *const ProfileChangeOldKey = @"ProfileChangeOldKey";
NSString *const ProfileChangeNewKey = @"ProfileChangeNewKey";

static NSString *const key = @"com.azaize.profile";
static Profile *globalProfile = nil;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static BOOL loadedFromDisk = NO;

@interface Profile () <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy, nullable) NSString *user_name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger language_id;
@property (nonatomic, assign) NSInteger currency_id;
@property (nonatomic, copy) NSString *lang_code;
@property (nonatomic, assign) NSInteger shoppingCartGoodsTotal;

@end

@implementation Profile

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.language_id = [aDecoder decodeIntegerForKey:@"language_id"];
        self.currency_id = [aDecoder decodeIntegerForKey:@"currency_id"];
        self.lang_code = [aDecoder decodeObjectForKey:@"lang_code"];
        self.shoppingCartGoodsTotal = [aDecoder decodeIntegerForKey:@"shoppingCartGoodsTotal"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeInteger:self.language_id forKey:@"language_id"];
    [aCoder encodeInteger:self.currency_id forKey:@"currency_id"];
    [aCoder encodeObject:self.lang_code forKey:@"lang_code"];
    [aCoder encodeInteger:self.shoppingCartGoodsTotal forKey:@"shoppingCartGoodsTotal"];
}

- (id)copyWithZone:(NSZone *)zone {
    Profile *copy = [Profile new];
    if (copy) {
        [copy setUser_id:[self.user_id copyWithZone:zone]];
        [copy setUser_name:[self.user_name copyWithZone:zone]];
        [copy setEmail:[self.email copyWithZone:zone]];
        [copy setLanguage_id:self.language_id];
        [copy setCurrency_id:self.currency_id];
        [copy setLang_code:[self.lang_code copyWithZone:zone]];
        [copy setShoppingCartGoodsTotal:self.shoppingCartGoodsTotal];
    }
    return copy;
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
                if ([globalProfile.modelToJSONObject modelIsEqual:[Profile new].modelToJSONObject]) globalProfile = nil; //Fix nil properties in Profile error.
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
            if (![oldProfile.modelToJSONObject modelIsEqual:newProfile.modelToJSONObject]) {
                globalProfile = newProfile.copy;
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:globalProfile];
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
