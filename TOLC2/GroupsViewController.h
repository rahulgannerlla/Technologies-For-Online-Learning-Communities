//
//  GroupsViewController.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/14/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "DetailedChatViewController.h"

@interface GroupsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ChatViewControllerDelegate>
{
    UITableView *mainTableView;
    ChatViewController *chatViewController;
    NSArray *sortedKeys;
    NSArray *fetchResults;
    ChatViewController *detailedViewController;

}

@property (nonatomic,strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
