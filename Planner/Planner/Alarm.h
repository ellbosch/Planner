//
//  Alarm.h
//  Planner
//
//  Created by Mark Vessalico on 5/4/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSString *time;
@property NSInteger *numTimesSelected;

@end