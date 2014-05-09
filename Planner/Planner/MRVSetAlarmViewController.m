//
//  MRVSetAlarmViewController.m
//  Planner
//
//  Created by Mark Vessalico on 4/19/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "MRVSetAlarmViewController.h"
#import "AlarmEnabledViewController.h"
#import "AlarmWrapper.h"
#import "Alarm.h"
#import "MRVAppDelegate.h"

@interface MRVSetAlarmViewController ()
{
    __weak IBOutlet UIDatePicker *alarmDatePicker;
    
    
}

@property (nonatomic, strong) NSString *userSelectedTime;
@property (nonatomic, strong) NSDate *userSelectedDate;
@property (nonatomic, strong) MPMediaItemCollection *userSelectedSong;

// date picker
- (void)pickerValueChanged:(id)sender;

// application delegate
@property (nonatomic, strong) MRVAppDelegate *appDelegate;


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

// lazy instantiate the app delegate
- (MRVAppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = (MRVAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
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
    alarmDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    _userSelectedSong = nil;

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
    
    // set userSelectedDate to originally loaded date if datePicker never changes
    if (_userSelectedDate == NULL) {
        _userSelectedDate = [NSDate date];
    }
    
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
    
    
    
    NSTimeInterval timeInterval = [_userSelectedDate timeIntervalSinceDate:[NSDate date]];
    NSLog(@"time interval: %f", timeInterval);
    
    
    
    /*** UI Notifications only support 30 second, pre loaded music files, so switching over to NSTimer to manually trigger alarm ***/
    /*
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = _userSelectedDate;
    notification.alertBody = [NSString stringWithFormat:@"Alert Fired at %@", _userSelectedDate];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
     */
    
    
    
   //DELETE THESE COMMENT MARKS!!
    
    /*** Add alarm to core data ***/
   /*
    // check if time already exists
    Alarm *existingAlarm = [self.appDelegate getAlarmFromTime:_userSelectedTime];
    if (existingAlarm) {
        existingAlarm.numTimesSelected = existingAlarm.numTimesSelected + 1;
    } else {
        // create new alarm object
        AlarmWrapper *alarm = [[AlarmWrapper alloc] init];
        alarm.time = _userSelectedTime;
        alarm.numTimesSelected = 0;
        if (![self.appDelegate postAlarmFromWrapper:alarm]) {
            UIAlertView *somethingWrong = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something was wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [somethingWrong show];
        }
    }
        

    */
    
    
    
    
    UIStoryboard *storyBoard = self.storyboard;
    AlarmEnabledViewController *alarmEnabledViewController = (AlarmEnabledViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"alarmEnabledViewController"];
    alarmEnabledViewController.alarmTimeString = _userSelectedTime;
    alarmEnabledViewController.alarmSong = _userSelectedSong;
    [self presentViewController:alarmEnabledViewController animated:YES completion:nil];
}

- (IBAction)setMusicButtonPress:(id)sender {
    MPMediaPickerController *musicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [musicPicker setDelegate:self];
    [musicPicker setAllowsPickingMultipleItems:NO];
    musicPicker.prompt = NSLocalizedString(@"Add song to play", "Prompt in media item picker");
    //[self presentViewController:musicPicker animated:YES completion:nil];
    [self.navigationController pushViewController:musicPicker animated:YES];
}

#pragma mark Date Picker

- (void)pickerValueChanged:(id)sender
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    _userSelectedDate = [sender date];
}

#pragma mark Media Picker
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker
   didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    //respond to picking media item
    //NSArray *items = mediaItemCollection.items;
    //MPMediaItem *song = items[0];
    _userSelectedSong = mediaItemCollection;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
