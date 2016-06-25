//
//  RegViewController.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HashTagViewController.h"
#import <Parse/Parse.h>

@interface RegViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *ageField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *confirmPasswordField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *cityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *zipField;
    IBOutlet UIImageView *placeholder;
    IBOutlet UIButton *addimage;
    IBOutlet UIButton *takePictureButton;
    IBOutlet UIButton *selectFromCameraRollButton;
    IBOutlet UIButton *nextButton;

}

@property(nonatomic,strong) UITextField *nameField;
@property(nonatomic,strong) UITextField *ageField;
@property(nonatomic,strong) UITextField *emailField;
@property(nonatomic,strong) UITextField *passwordField;
@property(nonatomic,strong) UITextField *confirmPasswordField;
@property(nonatomic,strong) UITextField *addressField;
@property(nonatomic,strong) UITextField *cityField;
@property(nonatomic,strong) UITextField *stateField;
@property(nonatomic,strong) UITextField *zipField;
@property(nonatomic,retain) UIButton *takePictureButton;
@property(nonatomic,retain) UIButton *selectFromCameraRollButton;
@property(nonatomic,retain) UIImageView *placeholder;
@property(nonatomic,retain) UIButton *addimage;
@property (nonatomic,retain) UIButton *nextButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(IBAction) next:(id) sender;
-(IBAction)uploadpic:(id)sender;


@end
