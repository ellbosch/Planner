//
//  WeatherManager.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/24/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherClient.h"
#import <TSMessages/TSMessage.h>

@interface WeatherManager ()

@property (nonatomic, strong, readwrite) WeatherModel *currentModel;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;

// Used for location finding and data fetching
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WeatherClient *client;

@end

@implementation WeatherManager

+ (instancetype)sharedManager
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    NSLog(@"singleton instance called");
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        // Creates location manager
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        // Creates client for handling networking and data parsing
        _client = [[WeatherClient alloc] init];
        
        // Observes currentLocation
        [[[[RACObserve(self, currentLocation) ignore:nil]
           // Flatten and subscribe to all 3 signals when currentLocation updates
           flattenMap:^(CLLocation *newLocation) {
               return [RACSignal merge:@[
                                         [self updateCurrentConditions],
                                         [self updateDailyForecast],
                                         [self updateHourlyForecast]
                                         ]];
               
               // Delivers signals to subscribers in main thread
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         // Display TSMessage banner if error occurs
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error"
                                         subtitle:@"There was a problem fetching the latest weather."
                                             type:TSMessageNotificationTypeError];
         }];
    }
    return self;
}

- (void)findCurrentLocation
{
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // We ignore first location update because it is usually cached
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    // Stop further updates when an accurate location is found
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}

- (RACSignal *)updateCurrentConditions
{
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WeatherModel *condition) {
        self.currentModel = condition;
        NSLog(@"%@", condition);
        
        
    }];
}

- (RACSignal *)updateHourlyForecast
{
    return [[self.client fetchHourlyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.hourlyForecast = conditions;
    }];
}

- (RACSignal *)updateDailyForecast
{
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.dailyForecast = conditions;
    }];
}

@end
