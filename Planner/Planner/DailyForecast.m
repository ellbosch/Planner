//
//  DailyForecast.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/23/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "DailyForecast.h"

@implementation DailyForecast

// Override call in WeatherModel to get correct high/low temp
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    return paths;
}

@end
