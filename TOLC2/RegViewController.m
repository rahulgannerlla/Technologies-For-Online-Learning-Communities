//
//  RegViewController.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "RegViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define kOFFSET_FOR_KEYBOARD 50.0

@interface RegViewController ()

@end

@implementation RegViewController
@synthesize nameField,ageField,emailField,passwordField,confirmPasswordField,addressField,cityField,stateField,zipField,placeholder,addimage,takePictureButton,selectFromCameraRollButton,nextButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Register";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hi.png"]];

}
- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) next:(id) sender{
    
   // NSLog(@"%")
    
   // if (![textField.text isEqualToString:@""]) {
    
    if (![nameField.text isEqualToString:@""] && ![ageField.text isEqualToString:@""] && ![emailField.text isEqualToString:@""]&& ![passwordField.text isEqualToString:@""]&& ![addressField.text isEqualToString:@""]&& ![cityField.text isEqualToString:@""]&& ![stateField.text isEqualToString:@""]&& ![zipField.text isEqualToString:@""]) {
        PFObject *recipe = [PFObject objectWithClassName:@"User"];
        [recipe setObject:nameField.text forKey:@"username"];
        [recipe setObject:ageField.text forKey:@"age"];
        [recipe setObject:emailField.text forKey:@"email"];
        [recipe setObject:passwordField.text forKey:@"password"];
        [recipe setObject:addressField.text forKey:@"address"];
        [recipe setObject:cityField.text forKey:@"city"];
        [recipe setObject:stateField.text forKey:@"state"];
        [recipe setObject:zipField.text forKey:@"zip"];
        
        [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Show success message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }];
        
        //  }
        
        HashTagViewController *hashTagViewController=[[HashTagViewController alloc]init];
        [self.navigationController pushViewController:hashTagViewController animated:YES];
    }
    else
    {
        UIAlertView *alertView= [[UIAlertView alloc]initWithTitle:@"Enter details" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    
    

}

-(IBAction)uploadpic:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.firstOtherButtonIndex + 0) {
        //code to take photo
        
        [self getCameraPicture:nil];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        //code to take access media
        [self selectExitingPicture];
    }
}
-(void)getCameraPicture:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsImageEditing = YES;
    picker.sourceType = (sender == takePictureButton) ?    UIImagePickerControllerSourceTypeCamera :
    UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController: picker animated:YES];
}
-(IBAction)selectExitingPicture
{
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsImageEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)info {
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSDictionary *metadataDict = [representation metadata];
        NSLog(@"%@",metadataDict);
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:[info objectForKey:UIImagePickerControllerMediaMetadata]];
    
    NSLog(@"meta data 123%@",metadata);
    
    
    [self dismissModalViewControllerAnimated:YES];
    placeholder.image = image;
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


-(IBAction) backgroundClick: (id) sender
{
    [passwordField resignFirstResponder];
    [ageField resignFirstResponder];
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    [confirmPasswordField resignFirstResponder];
    [addressField resignFirstResponder];
    [cityField resignFirstResponder];
    [stateField resignFirstResponder];
    [zipField resignFirstResponder];
    
}

-(IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way

    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{

    if ([sender isEqual:zipField])
    {
        NSLog(@"wwww");
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
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
