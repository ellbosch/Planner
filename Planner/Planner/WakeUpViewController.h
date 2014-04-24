//
//  WakeUpViewController.h
//  Planner
//
//  Created by Elliot Boschwitz on 4/21/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WakeUpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

@end
