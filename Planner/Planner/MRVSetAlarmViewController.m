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
    __weak IBOutlet UIDatePicker *alarmDatePicker;
    
    
}

@property (nonatomic, strong) NSString *userSelectedTime;
@property (nonatomic, strong) NSDate *userSelectedDate;

// date picker
- (void)pickerValueChanged:(id)sender;

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
    [alarmDatePicker addTarget:self
                    action:@selector(pickerValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    alarmDatePicker.backgroundColor = [UIColor whiteColor];
    alarmDatePicker.datePickerMode = UIDatePickerModeTime;
    alarmDatePicker.timeZone = [NSTimeZone localTimeZone];

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
    _userSelectedTime = [dateFormatter stringFromDate:_userSelectedDate];
    
    if ([_userSelectedDate compare:[NSDate date]] == NSOrderedAscending) {
        // Selected time is in the past
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:1];
        NSDate *updatedDate = [[NSCalendar currentCalendar]
                               dateByAddingComponents:dateComponents
                               toDate:_userSelectedDate
                               options:0];
        _userSelectedDate = updatedDate;
    }
    
    NSLog(@"user selected date: %@", _userSelectedDate);
    NSLog(@"user selected time: %@", _userSelectedTime);
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

- (void)pickerValueChanged:(id)sender
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    _userSelectedDate = [sender date];
}


@end
