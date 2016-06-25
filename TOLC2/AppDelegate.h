//
//  AppDelegate.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DDMenuController.h"
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@class DDMenuController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    BOOL newMessagesOnTop;
    NSMutableArray *chatArray;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) DDMenuController *menuController;
@end

