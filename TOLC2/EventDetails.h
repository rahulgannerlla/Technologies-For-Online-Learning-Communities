//
//  EventDetails.h
//  TOLC2
//
//  Created by Sachit Dhal on 10/31/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetails : NSObject{
    
}

/*
 
 "title": "Technologies for Online Learning Communities",
 "sdate": "2014-02-12T16:00-07:00:00",
 "edate": "2014-02-12T18:00-07:00:00",
 "location": "Starbucks, 1717 S Rural Road, Tempe, AZ 85281",
 "description": "Discussion about MOOCs  November 16, 2014",
 "pubDate": "Thu, 6 Feb 2014 03:47 PM (UTC)",
 "guid": "http://www.queencreek.org/about-us/components/event-calendar-list-view-all-events-/-item-15060?date=20140206074722"
 */

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sdate;
@property (nonatomic, strong) NSString *edate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *locationname;
@property (nonatomic, strong) NSString *locationaddress;

@property (nonatomic, strong) NSString *showdescription;


@end
