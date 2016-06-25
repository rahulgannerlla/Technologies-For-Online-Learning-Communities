//
//  AddEvent.m
//  TOLC2
//
//  Created by Sachit Dhal on 11/6/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "AddEvent.h"
#import "MyManager.h"

@interface AddEvent ()

@end

@implementation AddEvent
@synthesize meetingnotes,meetingtitle,checkintable,fsdata,fourConn,webData,message;
@synthesize name,addess,starttime,endtime,date,four_venue_zip,four_venue_add,four_venue_city,four_venue_name,picker,background,donedate,selected;

- (void)viewDidLoad {
    [super viewDidLoad];
    checkintable.hidden=YES;
    picker.hidden=YES;
    background.hidden=YES;
    donedate.hidden=YES;

    [picker setDate:[NSDate date] animated:YES];
    NSDate *now = [NSDate date];
    [picker setDate:now animated:YES];

    //    aEvent2.edate = @"2014-11-9T17:00-07:00:00";

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)displayDate:(id)sender {
    NSDate * selecteddate = [picker date];
    NSString * date = [selecteddate description];
    NSLog(@"Selected Date and Time: %@", date);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MMM dd yyyy, hh:mm a"];
    NSString *newDate = [dateFormatter stringFromDate:selecteddate];
    NSLog(@"Selected Date and Time: %@", newDate);
    
//    aEvent.sdate = @"2014-11-16T16:00-07:00:00";  4pm

    
    
    if ([selected isEqualToString:@"start"])
        starttime.text=newDate;
    if([selected isEqualToString:@"end"])
        endtime.text=newDate;
}


-(IBAction)donedateselected:(UIButton *)sender
{
    picker.hidden=YES;
    donedate.hidden=YES;
    background.hidden=YES;

}

-(IBAction)showPicker:(id)sender
{
    picker.hidden=NO;
    [self.view endEditing:YES];
    selected=@"start";
    background.hidden=NO;
    donedate.hidden=NO;

}
-(IBAction)showPicker2:(id)sender
{
    picker.hidden=NO;
    donedate.hidden=NO;

    [self.view endEditing:YES];
    selected=@"end";

    background.hidden=NO;
}

-(IBAction)foursquare:(UIButton *)sender{
    
    NSDate* date = [NSDate date];
    
    //Create the dateformatter object
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    //Set the required date format
    
    [formatter setDateFormat:@"yyyyMMdd"];
    
    //Get the string date
    
    NSString* str = [formatter stringFromDate:date];
    
    //Display on the console
    
    NSLog(@"date is %@",str);

    NSLog(@"date is %@",str);
    webData = [NSMutableData data];
    MyManager *sharedManager = [MyManager sharedManager];
    NSString *space=@"%20";

    NSString *url_string = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?near=85281&client_id=AOL5WAZ3WSXUW1Q1SRFAAD50JCX2H40CEOIZCJP13BCIPOPR&client_secret=MPPN0NG0VU45CNBEL4ICVVMLC1UULQC0P1R0IXJKXN2LIYSD&v=20140911&v=%@&query=%@",str,[name.text stringByReplacingOccurrencesOfString:@" " withString:space]];

    
//    NSString *url_string = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@,%@&oauth_token=MYRHBTAVV5ZKAOUJRC2NYHA1W40XHDAONAMNGR1EYFQAU1DF&v=%@",[sharedManager currentlatitude],[sharedManager currentlongitude],str];
    NSLog(@"fs url= %@",url_string);
    NSURL *url = [NSURL URLWithString:url_string];
    NSLog(@"fs string url= %@",url);
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    //[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    self.fourConn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( fourConn )
    {
        
        webData = [NSMutableData data] ;
        //
    }

    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{       [webData setLength: 0];
    NSLog(@"connection didrecieve response");
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [webData appendData:data];
    NSLog(@"connection didreceive data");
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:@"Connectiion Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"no conn");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *loginStatus = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    MyManager *sharedManager = [MyManager sharedManager];
    
    NSData *jsonData = [loginStatus dataUsingEncoding:NSUTF8StringEncoding];

//    NSLog(@"login status is= %@",loginStatus);
    NSError *localError = nil;

    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];

//    NSLog(@"parsed object %@",data);

    four_venue_city = [[NSMutableArray alloc]init];
    four_venue_add= [[NSMutableArray alloc]init];
    four_venue_name= [[NSMutableArray alloc]init];
    four_venue_zip= [[NSMutableArray alloc]init];

    fsdata=[[data objectForKey:@"response"]objectForKey:@"venues"];

    for(message in fsdata)
    {
        NSString *venuename=[message objectForKey:@"name"];
        NSLog(@"name venue is %@",venuename);
        NSString *venueadd=[[message objectForKey:@"location"]objectForKey:@"address"];
        NSString *venuecity=[[message objectForKey:@"location"]objectForKey:@"city"];
        NSString *venuezip=[[message objectForKey:@"location"]objectForKey:@"postalCode"];
       
        if(venueadd!=nil)
        {
            [four_venue_add addObject:venueadd];

        if(venuecity!=nil)
            
            [four_venue_city addObject:venuecity];
        else
            [four_venue_city addObject:@""];
        
       // NSLog(@"venuearray %@",four_venue_city);
        
      //  NSLog(@"venuearray %@",four_venue_add);
        if(venuename!=nil)
            
            [four_venue_name addObject:venuename];
        else
            [four_venue_name addObject:@""];
        
        
      //  NSLog(@"venuearray %@",four_venue_name);
        

        if(venuezip!=nil)
            
            [four_venue_zip addObject:venuezip];
        else
            [four_venue_zip addObject:@""];
        
        //NSLog(@"venuearray %@",four_venue_name);

        }
        
    }
    
    
    NSLog(@"4 venue city id %@",four_venue_city);
    NSLog(@"4 venue add id %@",four_venue_add);
    NSLog(@"4 venue name id %@",four_venue_name);
    NSLog(@"4 venue zip %@",four_venue_zip);

    [checkintable performSelector:@selector(reloadData)];
    [self showcheckin];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.four_venue_add count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView==checkintable)
        return @"Nearby Places";
    else
        return @" ";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyManager *sharedManager=[MyManager sharedManager];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        //        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    NSUInteger row=[indexPath row];
    cell.textLabel.text=[four_venue_name objectAtIndex:row];
    cell.detailTextLabel.text=[four_venue_add objectAtIndex:row];

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyManager *sharedManager=[MyManager sharedManager];
    NSUInteger row=[indexPath row];
    NSLog(@"selected name is %@",[four_venue_name objectAtIndex:row]);
    NSLog(@"selected address is %@",[four_venue_add objectAtIndex:row]);
    NSLog(@"selected city is %@",[four_venue_city objectAtIndex:row]);
    NSLog(@"selected zip is %@",[four_venue_zip objectAtIndex:row]);
   
    checkintable.hidden=YES;
    name.text=[four_venue_name objectAtIndex:row];
    addess.text=[four_venue_add objectAtIndex:row];
    
}
-(void)showcheckin
{
    [self.view endEditing:YES];

    checkintable.hidden=NO;
    [checkintable performSelector:@selector(reloadData)];
}
-(IBAction)cancelbutton:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(IBAction)donebutton:(UIButton *)sender{
    
    
    [self.view endEditing:YES];

    if (![meetingtitle.text isEqualToString:@""] && ![meetingnotes.text isEqualToString:@""] && ![addess.text isEqualToString:@""]&& ![name.text isEqualToString:@""]&& ![starttime.text isEqualToString:@""]&& ![endtime.text isEqualToString:@""]&& ![date.text isEqualToString:@""]) {
        
        
        
        
        PFObject *recipe = [PFObject objectWithClassName:@"Meeting"];
        [recipe setObject:meetingtitle.text forKey:@"title"];
        [recipe setObject:name.text forKey:@"locationName"];
        [recipe setObject:addess.text forKey:@"locationAddress"];
//        [recipe setObject:date.text forKey:@"date"];
        [recipe setObject:starttime.text forKey:@"stime"];
        [recipe setObject:endtime.text forKey:@"etime"];
        [recipe setObject:@"Notes about meeting" forKey:@"notes"];
        
        [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Show success message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meeting added" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];


            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some error occured" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }];

    
}
    else
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter all details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    }

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
