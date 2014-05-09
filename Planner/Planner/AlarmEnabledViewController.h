//
//  AlarmEnabledViewController.h
//  Planner
//
//  Created by Elliot Boschwitz on 4/20/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AlarmEnabledViewController : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *alarmTimeString;
@property NSTimeInterval *alarmTimeInterval;
@property MPMediaItemCollection *alarmSong;

//- (void)setAlarmTime:(NSString *)time;

@end
