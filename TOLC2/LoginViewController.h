//
//  LoginViewController.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MyManager.h"

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;

    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotPasswordButton;
    UITabBarController *tabBarController;
    NSDictionary *message;

}

@property(nonatomic,strong) UITextField *usernameField;
@property(nonatomic,strong) UITextField *passwordField;
@property(nonatomic,strong) UIButton *loginButton;
@property(nonatomic,strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSDictionary *message;

-(IBAction)loginButtonClicked:(id)sender;
-(IBAction)forgotButtonClicked:(id)sender;



@end
