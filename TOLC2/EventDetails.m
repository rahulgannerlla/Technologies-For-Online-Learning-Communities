//
//  EventDetails.m
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "EventDetails.h"

@implementation EventDetails

- (id) init {
    
    if (self = [super init]) {
        
        self.title = @"";
        self.sdate = @"";
        self.edate = @"";
        self.showdescription = @"";
        self.location =@"";
        self.locationname=@"";
        self.locationaddress=@"";
    }
    
    return self;
}

@end
