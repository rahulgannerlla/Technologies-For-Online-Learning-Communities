//  MyManager.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject{
    NSString *currentlatitude;
    NSString *currentlongitude;
    NSString *currentcity;
    NSString *loggedInUsername;
    NSString *loggedInName;
    NSString *loggedInAddress;
    NSString *loggedInCity;
    NSString *loggedInState;
    NSString *loggedInZip;
    NSString *loggedInAge;
    NSString *selectedEventTitle;
    NSString *selectedEventsdate;
    NSString *selectedEventedate;
    NSString *selectedEventlocation;
    NSString *selectedEventlocationname;
    NSString *selectedEventlocationAddress;

    NSString *selectedEventdescription;
    
}
@property (nonatomic, strong) NSString *currentlatitude;
@property (nonatomic, strong) NSString *currentlongitude;
@property (nonatomic, strong) NSString *currentcity;
@property (nonatomic, strong) NSString *loggedInUsername;
@property (nonatomic, strong) NSString *loggedInName;
@property (nonatomic, strong) NSString *loggedInAddress;
@property (nonatomic, strong) NSString *loggedInCity;
@property (nonatomic, strong) NSString *loggedInState;
@property (nonatomic, strong) NSString *loggedInZip;
@property (nonatomic, strong) NSString *loggedInAge;
@property (nonatomic, strong) NSString *selectedEventTitle;
@property (nonatomic, strong) NSString *selectedEventsdate;
@property (nonatomic, strong) NSString *selectedEventedate;
@property (nonatomic, strong) NSString *selectedEventlocation;
@property (nonatomic, strong) NSString *selectedEventlocationname;
@property (nonatomic, strong) NSString *selectedEventlocationAddress;

@property (nonatomic, strong) NSString *selectedEventdescription;


+ (id)sharedManager;

@end
