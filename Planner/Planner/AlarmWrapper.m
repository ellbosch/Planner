//
//  AlarmWrapper.m
//  Planner
//
//  Created by Mark Vessalico on 5/4/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "AlarmWrapper.h"

@implementation AlarmWrapper

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        _time = [decoder decodeObjectForKey:@"time"];
        _numTimesSelected = [decoder decodeIntegerForKey:@"numTimesSelected"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_time forKey:@"time"];
    [coder encodeInteger:*(_numTimesSelected) forKey:@"numTimesSelected"];
}

@end
