//
//  LoginViewController.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "LoginViewController.h"
#import "GroupsViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "LocationViewController.h"
#import "HashTagViewController.h"
#import "HistoryViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginButton,forgotPasswordButton,usernameField,passwordField,message;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"Login";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hi.png"]];

}
- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)loginButtonClicked:(id)sender{
    if (![usernameField.text isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"email" equalTo:usernameField.text];
        [query whereKey:@"password" equalTo:passwordField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //NSLog(@"%d",(int)objects.count);
                
                if (objects.count==0) {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid Login" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alertView show];
                }
                else
                {
                    //NSLog(@"%@",objects);
                    [[NSUserDefaults standardUserDefaults] setObject:[[objects objectAtIndex:0] objectForKey:@"username"] forKey:@"userId"];
                    [[NSUserDefaults standardUserDefaults]setObject:[[objects objectAtIndex:0]objectId] forKey:@"objectId"];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"objectId"]);
                    
                    MyManager *sharedManager=[MyManager sharedManager];
                    for(message in objects)
                    {
                        NSLog(@"address is %@", [message objectForKey:@"address"]);
                        sharedManager.loggedInAddress=[message objectForKey:@"address"];
                        sharedManager.loggedInAge=[message objectForKey:@"age"];
                        sharedManager.loggedInCity=[message objectForKey:@"city"];
                        sharedManager.loggedInUsername=[message objectForKey:@"email"];
                        sharedManager.loggedInState=[message objectForKey:@"state"];
                        sharedManager.loggedInZip=[message objectForKey:@"zip"];
                        sharedManager.loggedInName=[message objectForKey:@"username"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:sharedManager.loggedInName forKey:@"userId"];


                    GroupsViewController *groupsViewController=[[GroupsViewController alloc]init];
                    LocationViewController *locationViewController=[[LocationViewController alloc]init];
                    HashTagViewController *hashTagViewController=[[HashTagViewController alloc]init];
                    HistoryViewController *historyViewController=[[HistoryViewController alloc]init];
                    
                    groupsViewController.managedObjectContext=self.managedObjectContext;
                    hashTagViewController.managedObjectContext=self.managedObjectContext;
                    historyViewController.managedObjectContext=self.managedObjectContext;
                    locationViewController.managedObjectContext=self.managedObjectContext;
                    
                    tabBarController =[[UITabBarController alloc]init];
                    [tabBarController setViewControllers:[NSArray arrayWithObjects:groupsViewController,locationViewController,hashTagViewController,historyViewController,nil] animated:YES];
                    
                    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
                    
                    [menuController setRootController:navController animated:YES];
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    else
        NSLog(@"Invalid Input");
}
-(IBAction)forgotButtonClicked:(id)sender{
    
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
