//
//  HashTagViewController.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerTileView.h"
#import "DDMenuController.h"
#import "GroupsViewController.h"
#import "LocationViewController.h"
#import "HistoryViewController.h"

@interface HashTagViewController : UIViewController
{
    UIView *mainView;
    UIScrollView *mainScrollView;
    NSMutableArray *tileArray, *subjectsArray;
    UITableView *mainTableView;
    NSArray *colorsArray;
    UIButton *doneButton;
    UITabBarController *tabBarController;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
