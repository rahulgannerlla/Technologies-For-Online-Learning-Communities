//
//  NotesViewController.m
//  TOLC2
//
//  Created by Sachit Dhal on 11/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "NotesViewController.h"
#import "MyManager.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize textview,doneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    MyManager *sharedManager=[MyManager sharedManager];
    textview.text=[sharedManager selectedEventdescription ];

    // Do any additional setup after loading the view from its nib.
}

-(IBAction)doneClicked:(id)sender
{
    MyManager *sharedManager=[MyManager sharedManager];

    PFQuery *query = [PFQuery queryWithClassName:@"Meeting"];
    [query whereKey:@"title" equalTo:[sharedManager selectedEventTitle]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            // Found UserStats
            [userStats setObject:textview.text forKey:@"notes"];
            
            // Save
            [userStats saveInBackground];
            sharedManager.selectedEventdescription=textview.text;
            [self dismissViewControllerAnimated:YES completion:nil];

        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];

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
