//
//  AZLocationHandler.m
//  mobile
//
//  Created by abc on 2018/9/19.
//  Copyright © 2018年 azazie. All rights reserved.
//

#import <pthread/pthread.h>

#import "AZLocationHandler.h"
#import "WebsiteDataStore.h"

NSString *const APPLocationDidChangeNotification = @"APPLocationDidChangeNotification";
NSString *const LocationCookieName = @"sample_source";

static AZLocationHandler *defaultHandler = nil;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static NSString *const storeKey = @"com.azaize.location";
static NSString *const encodeKey = @"encode.location";

@interface AZLocationHandler ()

@property (nonatomic, strong) CLLocationManager *locator;

@end

@implementation AZLocationHandler

+ (AZLocationHandler *)defaultHaandler {
    
    pthread_mutex_lock(&mutex);
    {
        if (!defaultHandler)
        {
            NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:storeKey];
            if (encodedObject)
            {
                defaultHandler = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            }
            else
            {
                defaultHandler = [[AZLocationHandler alloc] initWithLocation:AZLocationAddress_America];
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:defaultHandler];
                [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:storeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    pthread_mutex_unlock(&mutex);
    return defaultHandler;
}

+ (BOOL)isAmericaLocated {
    return [AZLocationHandler defaultHaandler].location == AZLocationAddress_America;
}

+ (BOOL)isCanadaLocated {
    return [AZLocationHandler defaultHaandler].location == AZLocationAddress_Canada;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (void)setLocation:(AZLocationAddress)location {
    pthread_mutex_lock(&mutex);
    {
        if (location!=AZLocationAddress_America && location!=AZLocationAddress_Canada) {
            pthread_mutex_unlock(&mutex);
            return ;
        }
        if (defaultHandler && defaultHandler.location == location)
        {
            pthread_mutex_unlock(&mutex);
            return ;
        }
        
        AZLocationHandler *newLocation = [[AZLocationHandler alloc] initWithLocation:location];
        if (newLocation)
        {
            defaultHandler.location = newLocation.location;
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newLocation];
            [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:storeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            defaultHandler.location = AZLocationAddress_America;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:storeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    
        [WebsiteDataStore setCookieName:LocationCookieName value:newLocation.location == AZLocationAddress_Canada ? @"CA" : @"US"];
    }
    pthread_mutex_unlock(&mutex);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:APPLocationDidChangeNotification object:nil userInfo:nil];
}

+ (void)startDefaultLocat {
    AZLocationHandler *handler = [AZLocationHandler defaultHaandler];
    handler.locator = [[CLLocationManager alloc] init];
    handler.locator.desiredAccuracy = kCLLocationAccuracyBest;
    handler.locator.delegate = handler;
    [handler.locator requestWhenInUseAuthorization];
    [handler.locator startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locator stopUpdatingLocation];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *currentLocation = [locations lastObject];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"没有地址返回");
        if (placemarks.count >0)
        {
            CLPlacemark * placemark = placemarks.firstObject;
            NSString *ISOcountryCode = placemark.ISOcountryCode;
            if ([ISOcountryCode isEqualToString:@"CA"] && [AZLocationHandler defaultHaandler].location!=AZLocationAddress_Canada)
            {
                [AZLocationHandler setLocation:AZLocationAddress_Canada];
            }
        }
        else if (error == nil&&placemarks.count == 0)
        {
            NSLog(@"没有地址返回");
        }
        else if (error)
        {
            NSLog(@"location error:%@",error);
        }
    }];
}

#pragma mark - init & encode functions
- (instancetype)initWithLocation:(AZLocationAddress)location {
    if (self = [super init]) {
        _location = location;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    AZLocationAddress location = [[aDecoder decodeObjectForKey:encodeKey] integerValue];
    return [self initWithLocation:location];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.location] forKey:encodeKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[AZLocationHandler alloc] initWithLocation:self.location];
}

@end
