//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "GroupsViewController.h"
#import "LocationViewController.h"
#import "AppDelegate.h"

@implementation LeftController

@synthesize tableView=_tableView;
@synthesize listData;
@synthesize menuController=_menuController;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    NSArray *array;
    array =[[NSArray alloc]initWithObjects:@"Home",@"History",@"Settings",@"Logout", nil];

    self.listData=array;
    [self.tableView reloadData];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /* 
     * Content in this cell should be inset the size of kMenuOverlayWidth
     */
    NSUInteger row=[indexPath row];

    cell.textLabel.text=[listData objectAtIndex:row];
    if(row==0)
    {
        UIImage *image=[UIImage imageNamed:@"city.jpg"];
        cell.imageView.image=image;
    }
    if(row==1)
    {
        UIImage *image=[UIImage imageNamed:@"buzz.png"];
        cell.imageView.image=image;
        
    }
    if(row==2)
    {
        UIImage *image=[UIImage imageNamed:@"flo-icon.png"];
        cell.imageView.image=image;
        
    }
    if(row==3)
    {
        UIImage *image=[UIImage imageNamed:@"frnds.jpg"];
        cell.imageView.image=image;
    }
   
    return cell;
    
}


- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {

    return @"Clique";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // set the root controller
    NSUInteger row=[indexPath row];
    NSString *rowValue=[listData objectAtIndex:row];
    if(row==0)
    {
        
        GroupsViewController *groupsViewController=[[GroupsViewController alloc]init];
        LocationViewController *locationViewController=[[LocationViewController alloc]init];
        
        tabBarController =[[UITabBarController alloc]init];
        [tabBarController setViewControllers:[NSArray arrayWithObjects:groupsViewController,locationViewController,nil] animated:YES];
        
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
        
        [menuController setRootController:navController animated:YES];
    }
    if(row==3)
    {
        
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        MainViewController *controller = [[MainViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [menuController setRootController:navController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}



@end
