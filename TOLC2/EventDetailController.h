//
//  EventDetailController.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManager.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "NotesViewController.h"


@interface EventDetailController : UIViewController<MKMapViewDelegate>
{
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *backButton;
    UIAlertView *alert1;

    MyManager *sharedManager;
}
@property(nonatomic,strong) UIAlertView *alert1;
@property (nonatomic, retain) NotesViewController *notesevent;

@property(nonatomic,strong) MyManager *sharedManager;
@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) UIButton *backButton;
@property CLLocationCoordinate2D coords;

-(IBAction)backButtonPressed:(UIButton *)sender;
-(IBAction)addCalPressed:(UIButton *)sender;

@end
