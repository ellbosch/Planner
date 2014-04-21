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

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (void)fireTimer:(id)sender;

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
    
    alarmTimeLabel.adjustsFontSizeToFitWidth = YES;
    alarmTimeLabel.text = self.alarmTimeString;
    NSLog(@"new view time: %@", self.alarmTimeString);
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

#pragma mark Timer
- (void)fireTimer:(id)sender {
    NSLog(@"FIRE IN THE HOLE!!!");
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

@end
