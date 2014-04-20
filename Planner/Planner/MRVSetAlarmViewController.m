//
//  MRVSetAlarmViewController.m
//  Planner
//
//  Created by Mark Vessalico on 4/19/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "MRVSetAlarmViewController.h"
#import "AlarmEnabledViewController.h"

@interface MRVSetAlarmViewController ()
{

}

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *userSelectedTime;
//@property (nonatomic, strong) AlarmEnabledViewController *alarmEnabledView;

@end

@implementation MRVSetAlarmViewController

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
	// Do any additional setup after loading the view.
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set alarm once start button is pressed
- (IBAction)setAlarmButtonPress:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    _userSelectedTime = [dateFormatter stringFromDate:_datePicker.date];
    NSLog(@"date picker: %@", _datePicker.date);
    NSLog(@"time: %@", _userSelectedTime);
    
    /*
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = _datePicker.date;
    notification.alertBody = [NSString stringWithFormat:@"Alert Fired at %@", _datePicker.date];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
     */
    
    UIStoryboard *storyBoard = self.storyboard;
    AlarmEnabledViewController *alarmEnabledViewController = (AlarmEnabledViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"alarmEnabledViewController"];
    alarmEnabledViewController.alarmTimeString = _userSelectedTime;
    [self presentViewController:alarmEnabledViewController animated:YES completion:nil];
}


@end
