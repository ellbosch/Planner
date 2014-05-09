//
//  WakeUpViewController.h
//  Planner
//
//  Created by Elliot Boschwitz on 4/21/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WeatherModel.h"

@interface WakeUpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, AVSpeechSynthesizerDelegate, UIGestureRecognizerDelegate>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

@end
