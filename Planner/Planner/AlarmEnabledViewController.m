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
}

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (void)fireTimer:(id)sender;
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

    
    // schedule timer to go off for alarm
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:*(self.alarmTimeInterval)
                                                      target:self
                                                    selector:@selector(fireTimer:)
                                                    userInfo:nil
                                                     repeats:NO];
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

- (void) updateTime:(id)sender
{
    NSDate *StrDate = [NSDate date];
    NSDateFormatter *Dateformat = [[NSDateFormatter alloc]init];
    [Dateformat setDateFormat:@"HH:mm"];
    currentTime.text = [Dateformat stringFromDate:StrDate];
}

#pragma mark - Unlock Alarm

-(void)unlockAlarm
{
    NSLog(@"SWIPE DETECTION");
}

#pragma mark Timer
- (void)fireTimer:(id)sender {
    if (self.alarmSong) {
        // Used media picker to choose a song
        MPMusicPlayerController *musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
        [musicPlayerController setQueueWithItemCollection:_alarmSong];
        [musicPlayerController play];
    } else {
        alarmTimeLabel.text = [NSString stringWithFormat:@"Wake up :)"];
        [alarmTimeLabel sizeToFit];
        // play a default song
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Constellation" ofType:@"m4r"];
        NSLog(@"music path: %@", path);
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        [_audioPlayer play];
    }
}

#pragma mark - Show Alarm Activated View

- (IBAction)pressSimulateAlarmButton:(id)sender
{
    UIStoryboard *storyBoard = self.storyboard;
    AlarmActivatedViewController *alarmActivatedViewController = (AlarmActivatedViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"alarmActivatedViewController"];
    [self presentViewController:alarmActivatedViewController animated:YES completion:nil];   
    
}

@end
