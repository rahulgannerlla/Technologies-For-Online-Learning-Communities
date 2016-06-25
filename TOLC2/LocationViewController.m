//
//  LocationViewController.m
//  FrameworksForNewApplication
//
//  Created by Rahul Gannerlla on 9/29/14.
//  Copyright (c) 2014 TF Health. All rights reserved.
//

#import "LocationViewController.h"
#import "MyManager.h"


@interface LocationViewController ()

@end

@implementation LocationViewController

-(id)init{
    if(self==[super init]){
        self.title=@"Location / Start Chat";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    geocoder=[[CLGeocoder alloc]init];
    
    idArray=[[NSArray alloc]init];
    userArray=[[NSMutableArray alloc]init];
 
    locationButton=[[UIButton alloc]initWithFrame:CGRectMake(40, 80, 80, 40)];
    [locationButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]];
    [locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setTitle:@"Map me!" forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    locationButton.layer.cornerRadius=5.0;
    
    StartChat=[[UIButton alloc]initWithFrame:CGRectMake(180, 80, 100, 40)];
    [StartChat setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]];
    [StartChat addTarget:self action:@selector(startChatClicked) forControlEvents:UIControlEventTouchUpInside];
    [StartChat setTitle:@"Start chat!" forState:UIControlStateNormal];
    [StartChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    StartChat.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    StartChat.layer.cornerRadius=5.0;
    
    latitudeLocation=[[UILabel alloc]initWithFrame:CGRectMake(40, 140, 100, 40)];
    [latitudeLocation setText:@"Latitude"];
    [latitudeLocation setTextColor:[UIColor whiteColor]];
    latitudeLocation.textAlignment=NSTextAlignmentCenter;
    [latitudeLocation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]];
    latitudeLocation.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    latitudeLocation.layer.cornerRadius=5.0;
    
    latitudeTextField=[[UITextField alloc]initWithFrame:CGRectMake(160, 140, 100, 40)];
    latitudeTextField.delegate=self;
    latitudeTextField.layer.borderColor=[[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]CGColor];
    latitudeTextField.layer.borderWidth=2.0;
    latitudeTextField.enabled=NO;
    latitudeTextField.layer.cornerRadius=5.0;
    
    longitudeLocation=[[UILabel alloc]initWithFrame:CGRectMake(40, 190, 100, 40)];
    [longitudeLocation setText:@"Longitude"];
    [longitudeLocation setTextColor:[UIColor whiteColor]];
    longitudeLocation.textAlignment=NSTextAlignmentCenter;
    [longitudeLocation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]];
    longitudeLocation.font=[UIFont fontWithName:@"Helvetica" size:16.0];
    longitudeLocation.layer.cornerRadius=5.0;
    
    longitudeTextField=[[UITextField alloc]initWithFrame:CGRectMake(160, 190, 100, 40)];
    longitudeTextField.delegate=self;
    longitudeTextField.layer.borderColor=[[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]CGColor];
    longitudeTextField.layer.borderWidth=2.0;
    longitudeTextField.enabled=NO;
    longitudeTextField.layer.cornerRadius=5.0;
    
    addressView=[[UITextView alloc]initWithFrame:CGRectMake(20, 240, 280, 80)];
    [addressView setEditable:NO];
    addressView.layer.borderColor=[[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]]CGColor];
    addressView.layer.borderWidth=2.0;
    addressView.layer.cornerRadius=5.0;
    
     mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 320, 320, 568-44)];
    
    [self.view addSubview:locationButton];
    [self.view addSubview:StartChat];
    [self.view addSubview:latitudeLocation];
    [self.view addSubview:latitudeTextField];
    [self.view addSubview:longitudeLocation];
    [self.view addSubview:longitudeTextField];
    [self.view addSubview:addressView];
    [self.view addSubview:mapView];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    
    [self updateUserList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //[self updateUserList];
}

-(void)updateUserList{
    [userArray removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"pin" notEqualTo:@""];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            
            NSLog(@"%d",objects.count);
            
            for (int i =0;i<objects.count;i++) {
                NSDictionary *dic=[objects objectAtIndex:i];
                if ([[dic objectForKey:@"zip"] isEqualToString:pinCode]) {
                    [userArray addObject:dic];
                }
            }
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];}

-(void)startChatClicked{
    //chatViewController=[[ChatViewController alloc]init];
    if (![addressView.text isEqualToString:@""]) {
        
        
        //[self updateUserList];
        
       
        
        chatViewController=[[ChatViewController alloc]initWithIndex:10000];
        chatViewController.delegate=self;
        chatViewController.userArray=userArray;
        chatViewController.managedObjectContext=self.managedObjectContext;
        [self presentViewController:chatViewController animated:YES completion:nil];
    }
}

-(void)dismissChatViewController{
    [chatViewController dismissViewControllerAnimated:YES completion:nil];
    chatViewController=nil;
    
    self.tabBarController.selectedIndex=0;
}


-(void)locationButtonClicked{
    MKPointAnnotation *pinAtPoint = [[MKPointAnnotation alloc] init];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *latValue=[numberFormatter numberFromString:latitudeTextField.text];
    NSNumber *longValue=[numberFormatter numberFromString:longitudeTextField.text];
    
    for (id annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [latValue doubleValue];
    zoomLocation.longitude=  [longValue doubleValue];
    pinAtPoint.coordinate=zoomLocation;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
    [mapView setRegion:viewRegion animated:YES];
    [mapView addAnnotation:pinAtPoint];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    MyManager *sharedManager = [MyManager sharedManager];

    if (currentLocation != nil) {
        latitudeTextField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitudeTextField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        sharedManager.currentlatitude=[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        sharedManager.currentlongitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];

    }
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            addressView.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            
            pinCode=placemark.postalCode;
            [manager stopUpdatingLocation];
            
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            
            // Retrieve the object by id
            [query getObjectInBackgroundWithId:[[NSUserDefaults standardUserDefaults]objectForKey:@"objectId"] block:^(PFObject *userProfile, NSError *error) {
                userProfile[@"zip"] = pinCode;
                [userProfile saveInBackground];
                
            }];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    [self updateUserList];
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
