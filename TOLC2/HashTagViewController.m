//
//  HashTagViewController.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "HashTagViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

@interface HashTagViewController ()

@end

@implementation HashTagViewController

-(id)init{
    if(self==[super init]){
        self.title=@"Topics";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *heading=[[UILabel alloc]initWithFrame:CGRectMake(140, 40, 60, 30)];
    [heading setText:@"Topics"];
    [heading setTextColor:[UIColor blackColor]];
    [heading setFont:[UIFont fontWithName:@"Helvetica" size:19.0]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect=[[UIScreen mainScreen]bounds];
    tileArray=[[NSMutableArray alloc]init];
    subjectsArray=[[NSMutableArray alloc]init];
    colorsArray=[[NSArray alloc]initWithObjects:@"blue.png",@"green.png",@"orange.png",@"purple.png",@"red.png",@"yellow.png", @"orange.png",@"purple.png",nil];
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 68, rect.size.width, rect.size.height)];
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    [mainScrollView setBackgroundColor:[UIColor whiteColor]];
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 400, 300, 168) style:UITableViewStyleGrouped];
    mainTableView.layer.cornerRadius=4.0;
    
    [self.view addSubview:mainView];
    [mainView addSubview:mainScrollView];
    //[mainView addSubview:mainTableView];
    
    doneButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 525, 320, 43)];
    [doneButton setBackgroundColor:[UIColor darkGrayColor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [self.view addSubview:heading];
    
    [self loadTileViews];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Select atleast one topic" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
}

-(void)loadView{
    [super loadView];
    
}

-(void)doneButtonClicked{
    GroupsViewController *groupsViewController=[[GroupsViewController alloc]init];
    LocationViewController *locationViewController=[[LocationViewController alloc]init];
    HistoryViewController *historyViewController=[[HistoryViewController alloc]init];
    
    groupsViewController.managedObjectContext=self.managedObjectContext;
    historyViewController.managedObjectContext=self.managedObjectContext;
    
    tabBarController =[[UITabBarController alloc]init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:groupsViewController,locationViewController,self,historyViewController,nil] animated:YES];
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    [menuController setRootController:navController animated:YES];

}

-(void)loadTileViews{
    int totalNumberOfView=8;
    mainScrollView.contentSize=CGSizeMake(mainView.frame.size.width, 60+mainView.frame.size.height * totalNumberOfView/4.5 );
    
    [subjectsArray addObjectsFromArray:[NSArray arrayWithObjects:@"Algebra",@"Trigonometry",@"Calculus",@"Geometry",@"Number Theory",@"M1",@"M2",@"M3",@"M4", nil]];
    
    int xCoordinate=20, yCoordinate=24;
    for (int i=0; i<8; i++) {
        UIView *tileView=[[UIView alloc]initWithFrame:CGRectMake(xCoordinate, yCoordinate, 280, 110)];
        tileView.tag=i+1;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 2, 140, 11)];
        titleLabel.text=[subjectsArray objectAtIndex:i];
        titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        titleLabel.textColor=[UIColor blackColor];
        
        [tileView setBackgroundColor:[UIColor clearColor]];
        [tileView addSubview:titleLabel];
        
        yCoordinate=yCoordinate+120;
        [mainScrollView addSubview:tileView];
        [tileArray addObject:tileView];
    }
    
    
    
    for (UIView *tView in tileArray) {
        UIScrollView *miniScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height)];
        
        xCoordinate=10, yCoordinate=20;
        
        UIColor *tempColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[colorsArray objectAtIndex:tView.tag-1]]];
        
        for (int j=0; j<totalNumberOfView; j++) {
            InnerTileView *innerView=[[InnerTileView alloc]initWithFrame:CGRectMake(xCoordinate, yCoordinate, 60, 80)];
            [innerView setBackgroundColor:tempColor];
            xCoordinate=xCoordinate+80;
            innerView.tag=j+1;
            // innerView.checkButton add
            [miniScrollView addSubview:innerView];
        }
        
        miniScrollView.contentSize=CGSizeMake(280*totalNumberOfView/4, 100);
        [tView addSubview:miniScrollView];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
