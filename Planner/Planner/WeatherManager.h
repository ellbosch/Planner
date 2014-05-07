//
//  WeatherManager.h
//  Planner
//
//  Created by Elliot Boschwitz on 4/24/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherModel.h"

@interface WeatherManager : NSObject <CLLocationManagerDelegate>

// Singleton instance
+ (instancetype)sharedManager;

// Data that gets stored
@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong) WeatherModel *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

// Starts/refreshes current location and weather finding process
- (void)findCurrentLocation;

@end
