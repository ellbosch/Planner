//
//  AlarmEnabledViewController.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/20/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "AlarmEnabledViewController.h"

@interface AlarmEnabledViewController ()
{
    IBOutlet UILabel *alarmTimeLabel;
}

@end

@implementation AlarmEnabledViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alarmTimeLabel.text = self.alarmTimeString;
    NSLog(@"new view time: %@", self.alarmTimeString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)setAlarmTime:(NSString *)time
{
    // Set timeLabel
    alarmTimeLabel.text = time;
    NSLog(@"TIME!! %@", time);
}
*/
@end
