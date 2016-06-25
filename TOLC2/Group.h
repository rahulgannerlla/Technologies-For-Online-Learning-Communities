//
//  Group.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 11/3/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Group : NSManagedObject
@property (nonatomic, retain) NSString *groupChat;
@property (nonatomic) NSNumber* bookmark;
@property (nonatomic) NSNumber* groupId;
@property (nonatomic, retain) NSString *bookmarkname;

@end
