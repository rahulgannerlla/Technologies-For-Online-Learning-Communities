//
//  EventDetailController.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "EventDetailController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <CoreLocation/CoreLocation.h>

#import "EventDetails.h"

@interface EventDetailController () <EKEventEditViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    EventDetails *aEvent;
    NSInteger secCount;

}

@property (nonatomic, retain) UILabel *titleLbl;
@property (nonatomic, retain) UITableView *detailTbl;
@property (nonatomic, strong) EKEventStore *eventStore;


@end

@implementation EventDetailController
@synthesize eventStore,sharedManager,backButton,addButton,notesevent;

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedManager=[MyManager sharedManager];

    // Do any additional setup after loading the view from its nib.
//    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *addButtonBackgroundImg = [UIImage imageNamed:@"add_to_cal"];
//    self.addButton.frame = CGRectMake(200.0f, 70.0f, 30, 30);
//    [self.addButton setBackgroundImage:addButtonBackgroundImg forState:UIControlStateNormal];
//    [self.addButton addTarget:self action:@selector(addCalPressed) forControlEvents:UIControlEventTouchUpInside];
//    self.addButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
//    
//    [self.view addSubview:self.addButton];
//
//    self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 70.0f, 30, 30)];
//    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
//    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
//    
//    [self.view addSubview:self.backButton];


    if (sharedManager.selectedEventdescription.length > 0) {
        secCount = 3;
    }else{
        secCount = 2;
    }

    CGSize maximumSize = CGSizeMake(290, 9999);
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    CGSize stringSize = [sharedManager.selectedEventTitle sizeWithFont:textFont
                                 constrainedToSize:maximumSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect headingFrame = CGRectMake(15,110, 290,stringSize.height);
    self.titleLbl = [[UILabel alloc]initWithFrame:headingFrame];
    self.titleLbl.text = sharedManager.selectedEventTitle;
    self.titleLbl.textColor = [UIColor blackColor];
    self.titleLbl.backgroundColor = [UIColor clearColor];
    self.titleLbl.font = textFont;
    self.titleLbl.numberOfLines = 0;
    [self.titleLbl sizeToFit];
    [self.view addSubview:self.titleLbl];
    
    CGFloat remainingHeight;
    if (self.view.frame.size.height >= 568){
        remainingHeight = 504 - (stringSize.height+20);
    }else{
        remainingHeight = 416 - (stringSize.height+20);
    }
    
    CGFloat actualTblHeight;
    
    if ([self getTableheight] > remainingHeight) {
        actualTblHeight = remainingHeight;
    }else{
        actualTblHeight = [self getTableheight];
    }
    
    self.detailTbl = [[UITableView alloc]initWithFrame:CGRectMake(10, stringSize.height+150, 300, actualTblHeight)];
    self.detailTbl.delegate = self;
    self.detailTbl.dataSource = self;
    self.detailTbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTbl.separatorColor = [UIColor clearColor];
    self.detailTbl.backgroundColor = [UIColor clearColor];
    self.detailTbl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.detailTbl];
    [self.detailTbl reloadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.detailTbl reloadData];

}
-(CGFloat)getTableheight{
    
    CGSize maximumSize = CGSizeMake(300, 9999);
    
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    CGSize locString = [sharedManager.selectedEventlocation sizeWithFont:textFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height;
    if (locString.height < 40.0) {
        height = 40.0;
    }else{
        height = locString.height;
    }
    
    CGSize decString = [sharedManager.selectedEventdescription sizeWithFont:textFont
                                      constrainedToSize:maximumSize
                        
                                          lineBreakMode:NSLineBreakByWordWrapping];
    
    return (secCount*50+ 40 + height + decString.height+60);
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return secCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    
    switch (indexPath.section) {
        case 0:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mmZZZZ"];
            [dateFormatter setDateFormat:@"MMM dd yyyy, hh:mm a"];

            NSDate *eventStartDate = [dateFormatter dateFromString:sharedManager.selectedEventsdate];
            NSDate *eventEndDate = [dateFormatter dateFromString:sharedManager.selectedEventedate];
            
            [dateFormatter  setDateFormat:@"MM/dd/yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:eventStartDate];
            
            [dateFormatter setDateFormat:@"hh:mma"];
            NSString *starttiming = [dateFormatter stringFromDate:eventStartDate];
            NSString *endtiming = [dateFormatter stringFromDate:eventEndDate];
            
            NSString *dateStr = [[NSString alloc]initWithFormat:@"%@ %@ - %@",dateString,starttiming,endtiming];
            cell.textLabel.text = dateStr;
        }
            
            break;
        case 1:
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = sharedManager.selectedEventlocation;
            [cell.textLabel sizeToFit];
            break;
        case 2:
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = sharedManager.selectedEventdescription;
            [cell.textLabel sizeToFit];
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            alert1 = [[UIAlertView alloc]
                      initWithTitle:@"Open in Maps" message:@"Quit app and open directions in Maps" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open",nil];
            alert1.tag=1;
            [alert1 show];
            break;
            
        case 2:
            notesevent = [[NotesViewController alloc] init];
            [self presentViewController:notesevent animated:YES completion:nil];

            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(0, 0, 300, 50);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    NSString *text;
    switch (section) {
        case 0:
            text = @"Date:";
            break;
        case 1:
            text = @"Location:";
            break;
        case 2:
            text = @"Notes:";
            break;
            
        default:
            break;
    }
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    view.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:136.0/255.0 blue:43.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 40;
    }
    
    NSString *text;
    switch (indexPath.section) {
        case 1:
            text = sharedManager.selectedEventlocation;
            break;
        case 2:
            text = sharedManager.selectedEventedate;
            break;
        default:
            break;
    }
    
    CGSize maximumSize = CGSizeMake(300.0, 9999);
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    CGSize myStringSize = [text sizeWithFont:textFont
                           constrainedToSize:maximumSize
                               lineBreakMode:NSLineBreakByWordWrapping];
    if (myStringSize.height < 40.0) {
        return 40.0;
    }
    
    return myStringSize.height;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alert1.tag==1)
    {
        if(buttonIndex==1)
        {
            [self getDirections];
        }
    
    }}

-(IBAction)backButtonPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(IBAction)addCalPressed:(UIButton *)sender{
    if (self.eventStore == nil) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    
    BOOL needsToRequestAccessToEventStore = NO; // iOS 5 behavior
    EKAuthorizationStatus authorizationStatus = EKAuthorizationStatusAuthorized; // iOS 5 behavior
    
    if ([[EKEventStore class] respondsToSelector:@selector(authorizationStatusForEntityType:)]) {
        authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
    }
    
    if (needsToRequestAccessToEventStore) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"abc");
                    [self openCalendar:aEvent];
                });
            }
        }];
    } else if (authorizationStatus == EKAuthorizationStatusAuthorized) {
        NSLog(@"abdec");

        [self openCalendar:aEvent];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)openCalendar:(EventDetails *)event{
    NSLog(@"abcdef");

    NSString *startDateString = sharedManager.selectedEventsdate;
    NSString *endDateString = sharedManager.selectedEventedate;
    
    if (startDateString && endDateString) {
        
        EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mmZZZZ"];
        [dateFormatter setDateFormat:@"MMM dd yyyy, hh:mm a"];

        NSDate *eventStartDate = [dateFormatter dateFromString:startDateString];
        NSDate *eventEndDate = [dateFormatter dateFromString:endDateString];
        
        
        [dateFormatter setDateFormat:@"HH:mma"];
        
        //NSString *startTimeString = [dateFormatter stringFromDate:eventStartDate];
        //NSString *endTimeString = [dateFormatter stringFromDate:eventEndDate];
        
        // Populating the data
        sharedManager=[MyManager sharedManager];

        addController.eventStore = self.eventStore;
        addController.event.title = sharedManager.selectedEventTitle;
        addController.event.notes = sharedManager.selectedEventdescription;
        addController.event.location = sharedManager.selectedEventlocation;
        addController.event.startDate = eventStartDate;
        addController.event.endDate = eventEndDate;
        addController.editViewDelegate = self;
        [self presentViewController:addController animated:YES completion:nil];
    }else{
        
//        [QCUtils showAlertWithTitle:@"Queen Creek" message:@"The event dates do not seem to be valid"];
    }
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getDirections{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    MyManager *sharedManager =[MyManager sharedManager];
    NSString *addressString = [NSString stringWithFormat:@"%@",sharedManager.selectedEventlocationAddress];
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if (error) {
                         NSLog(@"Geocode failed with error: %@", error);
                         return;
                     }
                     
                     if (placemarks && placemarks.count > 0)
                     {
                         CLPlacemark *placemark = placemarks[0];
                         
                         CLLocation *location = placemark.location;
                         _coords = location.coordinate;
                         _coords = location.coordinate;
                         
                         NSLog(@"coordinates are %f, %f",location.coordinate.latitude,location.coordinate.longitude);
                         
                         [self showMap];
                     }
                 }];
}
-(void)showMap
{
    MyManager *sharedManager=[MyManager sharedManager];
    

    CLLocationCoordinate2D annotationCoord;
    

        MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: _coords addressDictionary: nil];
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = sharedManager.selectedEventlocationname;
//        destination.name = @"Starbucks";
        NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];
    }
@end
