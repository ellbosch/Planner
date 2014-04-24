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
    // 1
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    // 2
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    // 3
    return paths;
}

@end
