//
//  HistoryViewController.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 11/3/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import <CoreData/CoreData.h>
#import "DetailedChatViewController.h"

@class Group;

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *mainTableView;
    NSArray *fetchResults;
    NSMutableArray *selectedResults;
    UISegmentedControl *segmentedControl;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
