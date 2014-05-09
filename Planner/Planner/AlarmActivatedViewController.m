//
//  AlarmActivatedViewController.m
//  Planner
//
//  Created by Elliot Boschwitz on 5/9/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "AlarmActivatedViewController.h"
#import "WakeUpViewController.h"

@interface AlarmActivatedViewController ()
{
    IBOutlet UILabel *currentTime;
}

- (IBAction)simulateUnlockingAlarm:(id)sender;

@end

@implementation AlarmActivatedViewController

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
    
    // create UIGestureRecognizer, which is used to unlock the alarm
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(unlockAlarm)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // instantiate clock label
    currentTime.adjustsFontSizeToFitWidth = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0f // 1 second
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)unlockAlarm
{
    WakeUpViewController *wakeUpViewController = [[WakeUpViewController alloc] init];
    [self presentViewController:wakeUpViewController animated:YES completion:nil];
}

- (void)updateTime:(id)sender
{
    NSDate *StrDate = [NSDate date];
    NSDateFormatter *Dateformat = [[NSDateFormatter alloc]init];
    [Dateformat setDateFormat:@"HH:mm"];
    currentTime.text = [Dateformat stringFromDate:StrDate];
}

- (IBAction)simulateUnlockingAlarm:(id)sender
{
    WakeUpViewController *wakeUpViewController = [[WakeUpViewController alloc] init];
    [self presentViewController:wakeUpViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
