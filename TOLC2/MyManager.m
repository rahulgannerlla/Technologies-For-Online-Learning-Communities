//  MyManager.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "MyManager.h"
static MyManager *sharedMyManager = nil;

@implementation MyManager
@synthesize currentlatitude,currentlongitude,currentcity,loggedInAddress,loggedInCity,loggedInName,loggedInState,loggedInUsername,loggedInZip,loggedInAge,selectedEventdescription,selectedEventedate,selectedEventlocation,selectedEventsdate,selectedEventTitle,selectedEventlocationname,selectedEventlocationAddress;


#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)init {
    if (self = [super init]) {
        
        
        currentcity = @"Default Property Value";
        currentlatitude = @"Default Property Value";
        currentlongitude = @"Default Property Value";
        loggedInZip = @"Default Property Value";
        loggedInAddress = @"Default Property Value";
        loggedInCity = @"Default Property Value";
        loggedInName = @"Default Property Value";
        loggedInState = @"Default Property Value";
        loggedInUsername = @"Default Property Value";
        loggedInAge = @"Default Property Value";
        
        selectedEventTitle = @"Default Property Value";
        selectedEventsdate = @"Default Property Value";
        selectedEventedate = @"Default Property Value";
        selectedEventdescription = @"Default Property Value";
        selectedEventlocation = @"Default Property Value";
        selectedEventlocationname = @"Default Property Value";
        selectedEventlocationAddress = @"Default Property Value";

    }
    return self;
}

@end