//
//  DetailedChatViewController.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 11/4/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface DetailedChatViewController : UIViewController<UIScrollViewDelegate>
{
    UIView *mainView;
    UIScrollView *chatScrollView;
    Group *selectedGroup;
    int y;
}

-(id)initWithGroup:(Group*)group;
@end
