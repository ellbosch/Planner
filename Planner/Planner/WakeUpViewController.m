//
//  WakeUpViewController.m
//  Planner
//
//  Created by Elliot Boschwitz on 4/21/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import "WakeUpViewController.h"
#import "WeatherManager.h"
#import "MRVSetAlarmViewController.h"

@interface WakeUpViewController () {
   // boolean value ensures weather narration only happens once
    BOOL hasNarratedWeather;
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;
@property (nonatomic, strong) NSMutableArray *possibleGreetings;

@end

@implementation WakeUpViewController

- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    // instantiate hasNarrated and isLocked
    hasNarratedWeather = false;
    
    // create list of greetings
    _possibleGreetings = [[NSMutableArray alloc] init];
    [_possibleGreetings addObject:@"Top of the morning to you!"];
    [_possibleGreetings addObject:@"Why, hello there!"];
    [_possibleGreetings addObject:@"Greetings, master."];
    [_possibleGreetings addObject:@"Get your arse out of bed!"];
    [_possibleGreetings addObject:@"Ah, bullocks. It's time to get up."];
    [_possibleGreetings addObject:@"Ah, bullocks. It's time to get up."];
    [_possibleGreetings addObject:@"Crikey, you're still in bed? You were supposed to get up 30 minutes ago!"];
    
    
	self.screenHeight = [UIScreen mainScreen].bounds.size.height;
  /*
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.view addSubview:self.blurredImageView];
    */
    

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat temperatureWidth = headerFrame.size.width - 2*inset;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGPoint superCenter = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    CGRect temperatureFrame = CGRectMake(inset, superCenter.y - (temperatureHeight / 2), temperatureWidth, temperatureHeight);
    CGRect hiloFrame = CGRectMake(inset, temperatureFrame.size.height + temperatureFrame.origin.y, headerFrame.size.width - 2*inset, hiloHeight);
    
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    CGRect conditionsFrame = iconFrame;
    // make the conditions text a little smaller than the view
    // and to the right of our icon
    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
	// bottom left
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    // bottom left
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    // top
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    exitButton.backgroundColor = [UIColor clearColor];
    [exitButton addTarget:self
               action:@selector(returnHome)
     forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitle:@"Start Your Day" forState:UIControlStateNormal];
    exitButton.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    exitButton.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];

/*
    exitButton.text.Color = [UIColor whiteColor];
    exitButton.text = @"Loading...";
    exitButton.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    exitButton.textAlignment = NSTextAlignmentCenter;*/
    [header addSubview:exitButton];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
    
    // bottom left
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    
    // use ReactiveCocoa to subscribe for weather updates
    [[RACObserve([WeatherManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WeatherModel *newCondition) {
         temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         conditionsLabel.text = [newCondition.condition capitalizedString];
        // cityLabel.text = [newCondition.locationName capitalizedString];
         
         iconView.image = [UIImage imageNamed:[newCondition imageName]];
         
         // Call alarm narrator if valid weather data is sent
         if (newCondition != NULL) {
             [self narrateWeather:newCondition];
         }
     }];
    
    RAC(hiloLabel, text) = [[RACSignal combineLatest:@[
                                                       RACObserve([WeatherManager sharedManager], currentCondition.tempHigh),
                                                       RACObserve([WeatherManager sharedManager], currentCondition.tempLow)]
                                              reduce:^(NSNumber *hi, NSNumber *low) {
                                                  return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                              }]
                            deliverOn:RACScheduler.mainThreadScheduler];
    
    [[RACObserve([WeatherManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[RACObserve([WeatherManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[WeatherManager sharedManager] findCurrentLocation];
     
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Narration

- (void)narrateWeather:(WeatherModel *)condition
{
    if (!hasNarratedWeather) {
        // set hasNarratedWeather to true so this won't call again
        hasNarratedWeather = true;
        
        // round current temp and high temp to closest integer value
        double currentTemp = [condition.temperature doubleValue] + 0.5;
        int currentTempRounded = currentTemp;
        double highTemp = [condition.tempHigh doubleValue] + 0.5;
        int highTempRounded = highTemp;
        
        NSString *greeting = [self getRandomGreeting];
        
        // create string that will include details about how much warmer/colder the day will get
        NSString *forecast;
        if (highTempRounded > currentTempRounded) {
            if (highTempRounded - currentTempRounded < 5) {
                forecast = @"and will warm up a few degrees later today.";
            } else {
                forecast = [NSString stringWithFormat:@"and will warm up to %i degrees later today.", highTempRounded];
            }
        } else {
            if (currentTempRounded - highTempRounded < 5) {
                forecast = @"and will cool down a few degrees later today.";
            } else {
                forecast = [NSString stringWithFormat:@"and will cool down to %i degrees later today", highTempRounded];
            }
        }
        
        
        NSString *weatherDetails = [NSString stringWithFormat:@"The current temperature is %i degrees, ", currentTempRounded];
        
        NSString *speech = [NSString stringWithFormat:@"%@ " ". %@ %@", greeting, weatherDetails, forecast];
        
        // set voice utterance
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speech];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        utterance.pitchMultiplier = 1.1;
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.3;
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        [synth speakUtterance:utterance];
    }
}

// Return one of the many pre-loaded random greetings
- (NSString *)getRandomGreeting
{
    NSString *greeting;
    
    int size =  (int) [_possibleGreetings count];
    
    int randomIndex = arc4random_uniform(size);
    greeting = [_possibleGreetings objectAtIndex:randomIndex];
    
    return greeting;
}

#pragma mark - Table Layouts

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
        return MIN([[WeatherManager sharedManager].hourlyForecast count], 6) + 1;
    }
    return MIN([[WeatherManager sharedManager].dailyForecast count], 6) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }
        else {
            WeatherModel *weather = [WeatherManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }
        else {
            WeatherModel *weather = [WeatherManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather];
        }
    }
    
    return cell;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WeatherModel *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureDailyCell:(UITableViewCell *)cell weather:(WeatherModel *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",weather.tempHigh.floatValue,weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect screenSize = CGRectMake(0, 0, [UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y);
    /*
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;*/
}

- (void)returnHome
{
    //NSArray *viewControllers = self.navigationController.viewControllers;
    //UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
    
   // MRVSetAlarmViewController *root = (MRVSetAlarmViewController *)[self.navigationController.viewControllers objectAtIndex:0];
   // [self presentViewController:root animated:YES completion:NULL];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    /*
    MRVSetAlarmViewController *setAlarmViewController = [[MRVSetAlarmViewController alloc] init];
    setAlarmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"setAlarmViewController"];
    
    NSLog(@"INSTANTIATE: %@", setAlarmViewController);
    //MRVSetAlarmViewController *setAlarmViewController = (MRVSetAlarmViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"setAlarmViewController"];
    //[self presentViewController:setAlarmViewController animated:YES completion:nil];
    [self.navigationController pushViewController:setAlarmViewController animated:YES];
     */
}

@end