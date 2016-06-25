//
//  ChatViewController.h
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/13/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDDrawView.h"
#import "FDViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>
#import "Group.h"

@class Group;

@protocol ChatViewControllerDelegate <NSObject>

-(void)dismissChatViewController;

@end

@interface ChatViewController : UIViewController<UIScrollViewDelegate, FDDrawViewDelegate, FDViewControllerDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate, UIScrollViewDelegate,ChatViewControllerDelegate, UINavigationBarDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIView *optionsView;
    UINavigationController *navigationController;
    UITextField *bookmarknamefield;
    UIView *mainView;
    UIScrollView *chatScrollView;
    UIImageView *imageView, *tempImageView;
     UIView *realTimeMainView;
    
    
    NSArray *fetchResults;
    UIButton *endChatButton;
    UIButton *optionsButton;
    UIView *chatView;
    
    UITextView *chatTextView;
    UIButton *chatButton;
    
    FDViewController *fdViewController;
    
     UIView *socialNetworkView;
    
    NSArray *firebaseArray;
    
     int chatIndex;

    BOOL newMessagesOnTop;
    
    NSMutableArray *chatArray;
    NSMutableArray *chatBackUpArray;
    
    int chatCount;
    
    NSString *kFirebaseURL ;
    
    int y, j, controllerTag;
    int bookmarkSelected;
    
}
-(id)initWithIndex:(int)myIndex;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong)   NSMutableArray *userArray;
@property (nonatomic, weak) id <ChatViewControllerDelegate> delegate;
@property(nonatomic,strong) UITextField *bookmarknamefield;

@end
