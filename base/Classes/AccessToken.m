//
//  AccessToken.m
//  CoreUser
//
//  Created by Demi on 12/04/2017.
//  Copyright © 2017 Azazie. All rights reserved.
//

#import "AccessToken.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <pthread/pthread.h>
#import "Profile.h"
#import "WebsiteDataStore.h"
#import "util.h"

NSString *const AccessTokenDidChangeNotification = @"AccessTokenDidChangeNotification";
NSString *const AccessTokenDidChangeUserIDKey = @"AccessTokenDidChangeUserIDKey";
NSString *const AccessTokenChangeOldKey = @"AccessTokenChangeOldKey";
NSString *const AccessTokenChangeNewKey = @"AccessTokenChangeNewKey";


static NSString *const key = @"com.azaize.accesstoken";
static AccessToken *globalAccessToken = nil;

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static BOOL loadedFromDisk = NO;


@implementation AccessToken

- (instancetype)initWithTokenString:(NSString *)tokenString userID:(NSString *)userID expirationDate:(NSDate *)expirationDate refreshDate:(NSDate *)refreshDate
{
    self = [super init];
    if (self)
    {
        _tokenString = [tokenString copy];
        _userID = userID.copy;
        _expirationDate = expirationDate.copy;
        _refreshDate = refreshDate.copy;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[AccessToken alloc] initWithTokenString:self.tokenString
                                             userID:self.userID
                                     expirationDate:self.expirationDate
                                        refreshDate:self.refreshDate];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *tokenString = [aDecoder decodeObjectForKey:@keypath(self, tokenString)];
    NSString *userID = [aDecoder decodeObjectForKey:@keypath(self, userID)];
    NSDate *expirationDate = [aDecoder decodeObjectForKey:@keypath(self, expirationDate)];
    NSDate *refreshDate = [aDecoder decodeObjectForKey:@keypath(self, refreshDate)];
    
    return [self initWithTokenString:tokenString userID:userID expirationDate:expirationDate refreshDate:refreshDate];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tokenString forKey:@keypath(self, tokenString)];
    [aCoder encodeObject:self.userID forKey:@keypath(self, userID)];
    [aCoder encodeObject:self.expirationDate forKey:@keypath(self, expirationDate)];
    [aCoder encodeObject:self.refreshDate forKey:@keypath(self, refreshDate)];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (nullable AccessToken *)currentAccessToken
{
    pthread_mutex_lock(&mutex);
    {
        if (!loadedFromDisk)
        {
            loadedFromDisk = YES;
            NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (encodedObject)
            {
                globalAccessToken = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            }
        }
    }
    pthread_mutex_unlock(&mutex);
    return globalAccessToken;
}

+ (void)setCurrentAccessToken:(AccessToken *)token
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    pthread_mutex_lock(&mutex);
    {
        AccessToken *oldToken = globalAccessToken;
        AccessToken *newToken = token;
        
        if (oldToken == nil && newToken == nil)
        {
            pthread_mutex_unlock(&mutex);
            return;
        }
        
        
        if (newToken)
        {
            [WebsiteDataStore setCookieName:@"login_token" value:newToken.tokenString];
        }
        else /// remove cookies.
        {
            [WebsiteDataStore removeAllCookies];
        }
        
        if (oldToken && newToken && [oldToken.userID isEqualToString:newToken.userID])
        {
            userInfo[AccessTokenDidChangeUserIDKey] = @NO;
        }
        else
        {
            userInfo[AccessTokenDidChangeUserIDKey] = @YES;
        }
        
        if (oldToken)
        {
            userInfo[AccessTokenChangeOldKey] = oldToken;
        }
        if (newToken)
        {
            userInfo[AccessTokenChangeNewKey] = newToken;
        }
        
        if (token)
        {
            globalAccessToken = token.copy;
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:token];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:encodedObject forKey:key];
            [defaults synchronize];
        }
        else
        {
            globalAccessToken = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    pthread_mutex_unlock(&mutex);
    
    main_thread_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AccessTokenDidChangeNotification object:nil userInfo:userInfo];
    });
    
    [Profile setCurrentProfile:nil];
}

@end
