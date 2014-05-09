//
//  AlarmEnabledViewController.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/20/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "AlarmEnabledViewController.h"
#import "AlarmActivatedViewController.h"

@interface AlarmEnabledViewController ()
{
    IBOutlet UILabel *currentTime;
    IBOutlet UILabel *alarmTimeLabel;
    bool isAlarmDeactivated;
}

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

//- (void)fireTimer:(id)sender;


- (void)alarmDeactivates;
- (IBAction)pressSimulateAlarmButton:(id)sender;

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
    
    isAlarmDeactivated = false;
    
    // create UIGestureRecognizer, which is used to unlock the alarm
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(unlockAlarm)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];

    
    alarmTimeLabel.adjustsFontSizeToFitWidth = YES;
    alarmTimeLabel.text = self.alarmTimeString;
    NSLog(@"new view time: %@", self.alarmTimeString);
    
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

- (void)updateTime:(id)sender
{
    NSDate *StrDate = [NSDate date];
    NSDateFormatter *Dateformat = [[NSDateFormatter alloc]init];
    [Dateformat setDateFormat:@"HH:mm"];
    currentTime.text = [Dateformat stringFromDate:StrDate];
    
    // check to see if alarm should go off
    if ([currentTime.text isEqualToString:alarmTimeLabel.text] && !isAlarmDeactivated) {
        // set to true so this isn't called again
        isAlarmDeactivated = true;
        
        [self alarmDeactivates];
    }
}

#pragma mark - Unlock Alarm

-(void)unlockAlarm
{
    NSLog(@"SWIPE DETECTION");
}

#pragma mark - Show Alarm Activated View

- (void)alarmDeactivates
{
    if (self.alarmSong) {
        // Used media picker to choose a song
        MPMusicPlayerController *musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
        [musicPlayerController setQueueWithItemCollection:_alarmSong];
        [musicPlayerController play];
    } else {
        // play a default song
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Constellation" ofType:@"m4r"];
        NSLog(@"music path: %@", path);
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        [_audioPlayer play];
        [self pressSimulateAlarmButton:self];
    }
    
    UIStoryboard *storyBoard = self.storyboard;
    AlarmActivatedViewController *alarmActivatedViewController = (AlarmActivatedViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"alarmActivatedViewController"];
    [self presentViewController:alarmActivatedViewController animated:YES completion:nil];
}

- (IBAction)pressSimulateAlarmButton:(id)sender
{
    UIStoryboard *storyBoard = self.storyboard;
    AlarmActivatedViewController *alarmActivatedViewController = (AlarmActivatedViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"alarmActivatedViewController"];
    [self presentViewController:alarmActivatedViewController animated:YES completion:nil];
}

@end
