//
//  CalendarViewController.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailController.h"
#import "AddEvent.h"


@interface CalendarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *titleArray;
    NSArray *dateArray;
    NSMutableArray *dataArray;
    NSDictionary *dataDictionary;
    NSInteger selectedIndex;
    BOOL eventLoading;
    NSDictionary *message;

}
@property (nonatomic, retain) IBOutlet UITableView *eventTable;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) EventDetailController *eventDetailController;
@property (nonatomic, retain) AddEvent *addevent;
@property (nonatomic, retain) NSDictionary *message;


-(IBAction)backButtonPressed:(UIButton *)sender;
-(IBAction)addButtonPressed:(UIButton *)sender;


@end
