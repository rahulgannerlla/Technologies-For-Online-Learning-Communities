//
//  MainViewController.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/13/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RegViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize login,reg;


- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hi.png"]];
    
    rect=[[UIScreen mainScreen]bounds];

    login.layer.borderColor=[[UIColor blackColor]CGColor];
    login.layer.borderWidth=3.0;
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [mainView setBackgroundColor:[UIColor blackColor]];
    [mainView setAlpha:5.0];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [imageView setImage:[UIImage imageNamed:@"2.png"]];
    
    UIImageView *mapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 300, 338)];
    [mapImageView setImage:[UIImage imageNamed:@"map.png"]];
    
    [self.view addSubview:mainView];
    [mainView addSubview:imageView];
    // [imageView addSubview:mapImageView];
    [imageView bringSubviewToFront:mapImageView];
    
    [self performSelector:@selector(removeSplashScreen) withObject:self afterDelay:2.0];
    
}

-(void)removeSplashScreen{
    [UIView animateWithDuration:1.0 animations:^{
        mainView.frame=CGRectMake(0, -568, 320, 568);} completion:^(BOOL finished){
            [mainView removeFromSuperview];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginClicked:(id)sender
{
    LoginViewController *createobj =[[LoginViewController alloc]init];
    createobj.managedObjectContext=self.managedObjectContext;
    [self.navigationController pushViewController:createobj animated:YES];
    
}
-(IBAction)regClicked:(id)sender
{
    RegViewController *createobj =[[RegViewController alloc]init];
    createobj.managedObjectContext=self.managedObjectContext;
    [self.navigationController pushViewController:createobj animated:YES];
    
}


@end
