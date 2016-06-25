//
//  LeftController.h
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"


@interface LeftController : UIViewController{
    NSArray *listData;
    UITabBarController *tabBarController;
}
@property (nonatomic,retain) NSArray *listData;  
@property (retain, nonatomic) DDMenuController *menuController;

@property(nonatomic,retain) UITableView *tableView;

@end
