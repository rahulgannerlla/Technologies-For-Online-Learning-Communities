//
//  NotesViewController.h
//  TOLC2
//
//  Created by Sachit Dhal on 11/12/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NotesViewController : UIViewController
{
    IBOutlet UITextView *textview;
    IBOutlet UIButton *doneButton;
}
@property(nonatomic,strong) UITextView *textview;
@property(nonatomic,strong) UIButton *doneButton;
-(IBAction)doneClicked:(id)sender;

@end
