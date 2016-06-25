//
//  MainViewController.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/13/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    IBOutlet UIButton *login;
    IBOutlet UIButton *reg;
    CGRect rect;
    UIView *mainView;
    IBOutlet UILabel *mainLabel;

}

@property(nonatomic,strong) UIButton *login;
@property(nonatomic,strong) UIButton *reg;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(IBAction)loginClicked:(id)sender;
-(IBAction)regClicked:(id)sender;



@end
