//
//  WeatherClient.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/24/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "WeatherClient.h"
#import "WeatherModel.h"
#import "DailyForecast.h"

@interface WeatherClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WeatherClient

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    // Return signal
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // Fetch data from URL
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            // Handle retrieved data
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    
                    
                    NSLog(@"fetch JSON happened: %@", subscriber);
                    
                    
                    // Send subscriber to JSON serialized if JSON data exists
                    [subscriber sendNext:json];
                }
                else {
                    [subscriber sendError:jsonError];
                }
            }
            else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        
        // Starts network request when someone subscribes to the signal
        [dataTask resume];
        
        // Handles cleanup when signal is destroyed
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    // Formats URL from CLLocationCoordinate2D object
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"fetch current conditions happens");
    
    // Creates signal
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Converts JSON into WeatherModel object
        return [MTLJSONAdapter modelOfClass:[WeatherModel class] fromJSONDictionary:json error:nil];
    }];
}

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Maps JSON
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Builds RACSequence to perform ReactiveCocoa operations
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // Maps new list of objects
        return [[list map:^(NSDictionary *item) {
            // Converts JSON into WeatherModel object
            return [MTLJSONAdapter modelOfClass:[WeatherModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Use the generic fetch method and map results to convert into an array of Mantle objects
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Build a sequence from the list of raw JSON
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // Use a function to map results from JSON to Mantle objects
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[DailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

@end
