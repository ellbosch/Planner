//
//  WeatherModel.h
//  Planner
//
//  Created by Elliot Boschwitz on 4/21/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface WeatherModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humdity;
@property (nonatomic, strong) NSNumber *currentTemp;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *sunrise;
@property (nonatomic, strong) NSString *sunset;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *windBearing;
@property (nonatomic, strong) NSString *windSpeed;
@property (nonatomic, strong) NSString *icon;

- (NSString *)imageName;

@end
