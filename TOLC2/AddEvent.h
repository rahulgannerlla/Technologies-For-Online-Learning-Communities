//
//  AddEvent.h
//  TOLC2
//
//  Created by Sachit Dhal on 11/6/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface AddEvent : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableData *webData;
    NSURLConnection *fourConn;
    NSString *selected;
    IBOutlet UITextField *meetingtitle;
    IBOutlet UITextField *name;
    IBOutlet UITextField *addess;
    IBOutlet UITextField *date;
    IBOutlet UITextField *starttime;
    IBOutlet UITextField *endtime;
    IBOutlet UITextField *meetingnotes;

    NSDictionary *fsdata;
    NSDictionary *message;
    NSMutableArray *four_venue_name;
    NSMutableArray *four_venue_city;
    NSMutableArray *four_venue_add;
    NSMutableArray *four_venue_zip;
    
    IBOutlet UIDatePicker *picker;
    IBOutlet UIImageView *background;
    IBOutlet UIButton *donedate;
   
}
-(IBAction)displayDate:(id)sender;

-(IBAction)showPicker:(id)sender;

-(IBAction)foursquare:(UIButton *)sender;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSURLConnection *fourConn;
@property(nonatomic, retain) NSDictionary *fsdata;
@property(nonatomic, retain) NSDictionary *message;
@property(nonatomic, retain) IBOutlet UITableView *checkintable;
@property(nonatomic,retain) UIDatePicker *picker;

@property(nonatomic, retain) UIImageView *background;

@property(nonatomic, retain) UITextField *meetingtitle;
@property(nonatomic, retain) UITextField *name;
@property(nonatomic, retain) UITextField *addess;
@property(nonatomic, retain) UITextField *date;
@property(nonatomic, retain) UITextField *starttime;
@property(nonatomic, retain) UITextField *endtime;
@property(nonatomic, retain) UITextField *meetingnotes;

@property(nonatomic, retain) NSMutableArray *four_venue_name;
@property(nonatomic, retain) NSMutableArray *four_venue_city;
@property(nonatomic, retain) NSMutableArray *four_venue_add;
@property(nonatomic, retain) NSMutableArray *four_venue_zip;
@property(nonatomic, retain) NSString *selected;

@property(nonatomic, retain) UIButton *donedate;


-(IBAction)donedateselected:(UIButton *)sender;



-(IBAction)cancelbutton:(UIButton *)sender;
-(IBAction)donebutton:(UIButton *)sender;



@end
