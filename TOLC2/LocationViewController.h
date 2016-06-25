//
//  LocationViewController.h
//  FrameworksForNewApplication
//
//  Created by Rahul Gannerlla on 9/29/14.
//  Copyright (c) 2014 TF Health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ChatViewController.h"
#import <Parse/Parse.h>


@interface LocationViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate,ChatViewControllerDelegate>
{
    UIButton *locationButton, *StartChat;
    UILabel *latitudeLocation;
    UITextField *latitudeTextField;
    UITextField *longitudeTextField;
    UILabel *longitudeLocation;
    UITextView *addressView;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    MKMapView *mapView;
    NSString *pinCode;
    ChatViewController *chatViewController;
    NSArray *idArray;
    NSMutableArray *userArray;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
