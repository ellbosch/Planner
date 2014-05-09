//
//  MRVAppDelegate.h
//  Planner
//
//  Created by Mark Vessalico on 4/19/14.
//  Copyright (c) 2014 Mark Vessalico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRVAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
