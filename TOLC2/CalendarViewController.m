//
//  CalendarViewController.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "CalendarViewController.h"
#import "EventDetailController.h"
#import "MyManager.h"
#import "AddEvent.h"
#import "EventDetails.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize eventTable,backButton,addButton,eventDetailController,addevent;
@synthesize message;

-(void) viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Meeting"];
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
                MyManager *sharedManager=[MyManager sharedManager];
                NSMutableArray *dataHolder =[[NSMutableArray alloc]init];

                for(message in objects)
                {
                    EventDetails *aEvent = [[EventDetails alloc]init];
                    
                    aEvent.title = [message objectForKey:@"title"];
                    aEvent.locationname=[message objectForKey:@"locationName"];
                    aEvent.locationaddress=[message objectForKey:@"locationAddress"];
                    aEvent.location = [NSString stringWithFormat:@"%@, %@",[message objectForKey:@"locationName"],[message objectForKey:@"locationAddress"]];
                    aEvent.sdate = [message objectForKey:@"stime"];
                    aEvent.edate = [message objectForKey:@"etime"];
                    aEvent.showdescription = [message objectForKey:@"notes"];
                    
                    [dataHolder addObject:aEvent];
                    
                    NSLog(@"title is %@", [message objectForKey:@"title"]);
                    NSLog(@"location name is %@", [message objectForKey:@"locationName"]);
                    NSLog(@"addess is %@", [message objectForKey:@"locationAddress"]);
                    NSLog(@"start time is %@", [message objectForKey:@"stime"]);
                    NSLog(@"end time is %@", [message objectForKey:@"etime"]);
                    NSLog(@"notes is %@", [message objectForKey:@"notes"]);


                }
                NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"sdate"
                                                    ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                dataArray = [NSMutableArray arrayWithArray:[dataHolder sortedArrayUsingDescriptors:sortDescriptors]];
                
                
                dataArray = dataHolder;
                [self.eventTable performSelector:@selector(reloadData)];


            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hi.png"]];
    
//    NSMutableArray *dataHolder =[[NSMutableArray alloc]init];
//    
//    
//    EventDetails *aEvent = [[EventDetails alloc]init];
//    aEvent.title = @"MOOCs";
//    aEvent.sdate = @"2014-11-16T16:00-07:00:00";
//    aEvent.edate = @"2014-11-16T17:00-07:00:00";
//    aEvent.showdescription = @"Discussion about MOOCs  November 16, 2014";
//    aEvent.location = @"Starbucks, 1717 S Rural Road, Tempe, AZ 85281";
//    
//    [dataHolder addObject:aEvent];
//    
//    EventDetails *aEvent2 = [[EventDetails alloc]init];
//    
//    aEvent2.title = @"Learner Profiles";
//    aEvent2.sdate = @"2014-11-9T16:00-07:00:00";
//    aEvent2.edate = @"2014-11-9T17:00-07:00:00";
//    aEvent2.showdescription = @"Discussion about Learner Profiles  November 16, 2014";
//    aEvent2.location = @"Starbucks, 1717 S Rural Road, Tempe, AZ 85281";
//    
//    [dataHolder addObject:aEvent2];
//    
//    EventDetails *aEvent3 = [[EventDetails alloc]init];
//    
//    aEvent3.title = @"Peer Reviews";
//    aEvent3.sdate = @"2014-10-26T16:00-07:00:00";
//    aEvent3.edate = @"2014-10-26T17:00-07:00:00";
//    aEvent3.showdescription = @"Discussion about Peer Reviews  November 16, 2014";
//    aEvent3.location = @"Starbucks, 1717 S Rural Road, Tempe, AZ 85281";
//    
//    [dataHolder addObject:aEvent3];
//    
//    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
//                                        sortDescriptorWithKey:@"sdate"
//                                        ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
//    dataArray = [NSMutableArray arrayWithArray:[dataHolder sortedArrayUsingDescriptors:sortDescriptors]];
//    
//    
//    dataArray = dataHolder;
    
    
    
    //    [self.eventTable reloadData];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    EventDetails *aEvent = [dataArray objectAtIndex:indexPath.row];
    NSString *titleString = aEvent.title;
    
    //NSString *dateString = aEvent.pubDate;;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = titleString;
    
    [cell.imageView setImage:[UIImage imageNamed:@"month_and_day_icon.png"]];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(105,80+1, 210, 4)];
    line.backgroundColor = [UIColor brownColor];
    [cell addSubview:line];
    line.backgroundColor = [UIColor colorWithRed:196.0/255.0 green:184.0/255.0 blue:129.0/255.0 alpha:1.0];
    CGFloat xcoord;
    
    
    
    //NSRange r = NSMakeRange(0, 21);
    //NSString *subDateString = [dateString substringWithRange: r];
    //NSDate *articleDate;
    //NSLog(@"date is %@",subDateString);
    
    
    //articleDate = [NSDate dateFromInternetDateTimeString:subDateString formatHint:DateFormatHintRFC3339];
    
    // articleDate = [NSDate dateFromInternetDateTimeString:subDateString formatHint:DateFormatHintRFC3339];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mmZZZZ"];
    [dateFormatter setDateFormat:@"MMM dd yyyy, hh:mm a"];
    
    NSDate *eventStartDate = [dateFormatter dateFromString:aEvent.sdate];
    
    [dateFormatter  setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:eventStartDate];
    
    [dateFormatter setDateFormat:@"hh:mma"];
    NSString *timing = [dateFormatter stringFromDate:eventStartDate];
    
    NSString *detailLblTxt = [[NSString alloc]initWithFormat:@"%@ %@",dateString,timing];
    
    cell.detailTextLabel.text = detailLblTxt;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MMM"] ;
    NSString *month = [dateFormatter stringFromDate:eventStartDate];
    
    [dateFormatter setDateFormat:@"dd"] ;
    NSString *day = [dateFormatter stringFromDate:eventStartDate];
    
    
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(xcoord,25, 80, 25)];
    monthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    monthLabel.numberOfLines = 1;
    monthLabel.text = month;
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.textColor = [UIColor blackColor];
    [cell addSubview:monthLabel];
    
    UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(xcoord+2, 45, 70, 40)];
    dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    
    dayLabel.text = day;
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.textColor = [UIColor blackColor];
    [cell addSubview:dayLabel];
    
    
    
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 85.00;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath.row;
    MyManager *sharedManager=[MyManager sharedManager];
    
    EventDetails *aEvent = [dataArray objectAtIndex:indexPath.row];
    
    sharedManager.selectedEventTitle=aEvent.title;
    sharedManager.selectedEventdescription=aEvent.showdescription;
    sharedManager.selectedEventlocation=aEvent.location;
    sharedManager.selectedEventsdate=aEvent.sdate;
    sharedManager.selectedEventedate=aEvent.edate;
    sharedManager.selectedEventlocationname=aEvent.locationname;
    sharedManager.selectedEventlocationAddress=aEvent.locationaddress;
    
    eventDetailController = [[EventDetailController alloc] init];
    // eventDetailController.delegate = self;
    //    [self.navigationController pushViewController:eventDetailController animated:YES];
    
    [self presentViewController:eventDetailController animated:YES completion:nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(EventDetails *)getEventDetails{
    EventDetails *aEvent = [dataArray objectAtIndex:selectedIndex];
    return aEvent;
}


-(IBAction)backButtonPressed:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)addButtonPressed:(UIButton *)sender{
    
    addevent = [[AddEvent alloc] init];
    
    [self presentViewController:addevent animated:YES completion:nil];
    
    
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
