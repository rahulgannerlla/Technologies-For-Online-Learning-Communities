//
//  ChatViewController.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/13/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "ChatViewController.h"
#import <Firebase/Firebase.h>
#import "CalendarViewController.h"
#import "FDDrawView.h"
#import "CalendarViewController.h"

// Replace this with your own Firebase
//static NSString * const kFirebaseURL = @"https://chattolc.firebaseIO.com";

#define kFirechatNS @"https://drawtexteditor.firebaseIO.com"

@interface ChatViewController ()
// A set of paths by this user that have not been acknowlegded by the server yet
@property (nonatomic, strong) NSMutableSet *outstandingPaths;

// The handle that was returned for observing child events
@property (nonatomic) FirebaseHandle childAddedHandle;

// The firebase this demo uses
@property (nonatomic, strong) Firebase *firebase;

// The firebase this demo uses
@property (nonatomic, strong) Firebase *notificationFirebase;

// The current state of the paths drawn
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) FDDrawView *drawView;


@end

@implementation ChatViewController
@synthesize bookmarknamefield;

-(id)initWithIndex:(int)myIndex{
    self=[super init];
    
    chatIndex=myIndex;
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    firebaseArray=[[NSArray alloc]initWithObjects:@"https://chattolc.firebaseIO.com", @"https://chattolc2.firebaseIO.com",@"https://chattolc3.firebaseIO.com",@"https://chattolc4.firebaseIO.com",@"https://chattolc5.firebaseIO.com",@"https://chattolc6.firebaseIO.com",@"https://chattolc7.firebaseIO.com",@"https://chattolc8.firebaseIO.com",@"https://chattolc9.firebaseIO.com", nil];
    
   // NSString *kFirebaseURL ;
    
    if (chatIndex==10000) {
        [self fetchData];
        chatCount=[fetchResults count];
        
        if (chatCount==9) {
            
        }
        kFirebaseURL=[firebaseArray objectAtIndex:chatCount];
    }else{
        kFirebaseURL=[firebaseArray objectAtIndex:chatIndex];
        chatCount=chatIndex;
    }
    
    
    
    navigationController = [[UINavigationController alloc] init];
    [self.view addSubview:navigationController.view];

    j=0;
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 568-50-65)];
    [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chatbg.png"]]];
    
    chatScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 320, 568-50-65)];
    [chatScrollView setScrollEnabled:YES];
    chatScrollView.delegate=self;
    
    y=10;
    
    for (NSString *users in self.userArray) {
        NSLog(@"%@",users);
    }
    
    chatArray=[[NSMutableArray alloc]init];
    chatBackUpArray=[[NSMutableArray alloc]init];
    
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirebaseURL];
    self.notificationFirebase=[[Firebase alloc]initWithUrl:@"https://chattolc8.firebaseio.com"];
    
    bookmarkSelected=0;
    
    
//    // Pick a random number between 1-1000 for our username.
//    self.name = [NSString stringWithFormat:@"Guest%d", arc4random() % 1000];
//    [nameField setTitle:self.name forState:UIControlStateNormal];
    
    // Decide whether or not to reverse the messages
    newMessagesOnTop = YES;
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if (newMessagesOnTop) {
            [chatArray insertObject:snapshot.value atIndex:0];
           // [self loadScrollView];
        } else {
            [chatArray addObject:snapshot.value];
           
        }
        
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
           // [self.tableView reloadData];
              NSLog(@"   %@",[chatArray objectAtIndex:0]);
            
            NSDictionary *dic=[chatArray objectAtIndex:0];
            
            if([dic[@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]])
              [self.notificationFirebase setValue:@{@"name":[[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] stringByAppendingString:[NSString stringWithFormat:@"  -  %@",dic[@"text"]]]}];
            
            [NSNotificationCenter defaultCenter];
            
            [self loadScrollView];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
      //  [self.tableView reloadData];
        [self loadScrollView];
      
        initialAdds = NO;
    }];

    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"chatbg.png"]];
    
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"greyButton.png"];
    
    
    optionsButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 80, 35)];
    [optionsButton setTitle:@"Options" forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(showOptionsPane) forControlEvents:UIControlEventTouchUpInside];
    optionsButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0];
    [optionsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
   // [optionsButton setBackgroundColor:[UIColor lightGrayColor]];
    [optionsButton setBackgroundImage:[buttonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(21.0, 21.0, 21.0, 21.0)] forState:UIControlStateNormal];
    
    endChatButton=[[UIButton alloc]initWithFrame:CGRectMake(210, 30, 90, 35)];
    [endChatButton setTitle:@"End Chat" forState:UIControlStateNormal];
    [endChatButton addTarget:self action:@selector(closeChatViewController) forControlEvents:UIControlEventTouchUpInside];
    endChatButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0];
    [endChatButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
   // [endChatButton setBackgroundColor:[UIColor lightGrayColor]];
    [endChatButton setBackgroundImage:[buttonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(21.0, 21.0, 21.0, 21.0)] forState:UIControlStateNormal];
    
   
    
    
    optionsView=[[UIView alloc]initWithFrame:CGRectMake(10, 568, 300, 240)];
    optionsView.layer.cornerRadius=6.0;
    [optionsView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    optionsView.layer.borderColor=[[UIColor blackColor]CGColor];
    optionsView.layer.borderWidth=2.0;
    optionsView.hidden=YES;
    
    chatView=[[UIView alloc]initWithFrame:CGRectMake(0, 518, 320, 50)];
    [chatView setBackgroundColor:[UIColor darkGrayColor]];
    
    chatTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, 240, 30)];
    chatTextView.layer.cornerRadius=4.0;
    chatTextView.delegate=self;
    chatTextView.returnKeyType=UIReturnKeyDefault;
    
    chatButton=[[UIButton alloc]initWithFrame:CGRectMake(250, 5, 70, 40)];
    [chatButton setTitle:@"Send" forState:UIControlStateNormal];
    [chatButton setBackgroundColor:[UIColor clearColor]];
    [chatButton addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:optionsButton];
    [self.view addSubview:optionsView];
    [self.view addSubview:endChatButton];
    
    [mainView addSubview:chatScrollView];
    [self.view addSubview:mainView];
    
    [self.view addSubview:chatView];
    [chatView addSubview:chatTextView];
    [chatView addSubview:chatButton];
    
    [self loadOptionsPane];
    
    [self.view bringSubviewToFront:optionsView];
    [self.view bringSubviewToFront:optionsButton];
    [self.view bringSubviewToFront:endChatButton];
    [self.view bringSubviewToFront:chatView];
    
  //  [self loadScrollView];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

-(void)loadScrollView{
    //int y=100;
    
 //   NSLog(@"%d  ",chatArray.count);
    
    for (int i=chatArray.count-1; i>=0; i--) {
        
       // NSLog(@"%@",chatArray[i]);
        chatBackUpArray[j]=chatArray[i];
        j++;
        
        NSDictionary *chatDic=chatArray[i];
        UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(10, y, 0, 0)];
        tempView.layer.cornerRadius=4.0;
        [tempView setBackgroundColor:[UIColor whiteColor]];
        
        NSString *tempString=chatDic[@"text"];
        NSString *subStringToHandleImage;
        if(tempString.length>3)
             subStringToHandleImage=[tempString substringToIndex:4];
        
        NSLog(@"%d",tempString.length);
        NSString *chatString;
        
        
        if (![tempString isEqualToString:@""]) {
            if ([subStringToHandleImage isEqualToString:@"abcd"]) {
                NSString *imageString=[tempString substringWithRange:NSMakeRange(4, tempString.length-4)];
                NSLog(@"%d",imageString.length);
                UIImage *image=[self stringToUIImage:imageString];
                chatString=[NSString stringWithFormat:@"%@",chatDic[@"name"]];
                
                UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
                imgView.frame=CGRectMake(10, 10, 80, 100);
                
                UILabel *chatLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
                [chatLabel setText:chatString];
                [chatLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
                [chatLabel setTextColor:[UIColor blackColor]];
                
                //[chatLabel addSubview:imgView];
                [chatLabel sizeToFit];
                
                if([chatDic[@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]])
                    tempView.frame=CGRectMake(10, y, imgView.frame.size.width, imgView.frame.size.height);
                else
                    tempView.frame=CGRectMake(240, y, imgView.frame.size.width, imgView.frame.size.height);
                
                y=y+120;
                [tempView addSubview:imgView];
                
                
                
            }
            else{
                chatString=[NSString stringWithFormat:@"%@ - %@",chatDic[@"name"],chatDic[@"text"]];
                
                UILabel *chatLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
                [chatLabel setText:chatString];
                [chatLabel sizeToFit];
                [chatLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
                [chatLabel setTextColor:[UIColor blackColor]];
                [chatLabel setNumberOfLines:2];
                
                if([chatDic[@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]])
                    tempView.frame=CGRectMake(10, y, chatLabel.frame.size.width, chatLabel.frame.size.height);
                else{
                  
                    tempView.frame=CGRectMake(200, y, 120, chatLabel.frame.size.height);
                }
                
                
                y=y+30;
                [tempView addSubview:chatLabel];
            }
            
            [chatScrollView addSubview:tempView];
            
        }
        
        //    for (NSDictionary *chatDic in chatArray) {
        //        
        //    }
        
        [chatScrollView setContentSize:CGSizeMake(320, y+150)];
        
        [chatScrollView scrollRectToVisible:CGRectMake(0, y-30, 320, 568) animated:YES];
        
        
        //if (chatIndex==10000)
        
        }
        
        [chatArray removeAllObjects];
}

-(void)sendChat{
    NSString* temp=chatTextView.text;
    //[chatTextView resignFirstResponder];
    
   // self.notificationFirebase
    
    //[self.notificationFirebase setValue:temp];@{@"name" : [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
    
   // [[self.notificationFirebase childByAutoId] setValue:@{@"name" : [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"text": temp}];
     [[self.firebase childByAutoId] setValue:@{@"name" : [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"text": temp}];
    [chatTextView setText:@""];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^(void){
        if(y>150)
            mainView.frame=CGRectMake(0, -150, 320, 568-50);
        chatView.frame=CGRectMake(0, 295, 320, 50);
        
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^(void){
        mainView.frame=CGRectMake(0, 65, 320, 568-50-65);
        chatView.frame=CGRectMake(0, 518, 320, 50);
    }];
}

-(void)fetchData{
    fetchResults=nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Execute the fetch.
    NSError *error = nil;
    fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Handle the error.
        NSLog(@": %@", error.userInfo);
    } else {
        if ([fetchResults count] > 0) {
        }
    }
}


-(void)closeChatViewController{
    //NSLog(@"%d",chatBackUpArray.count);
    if (chatBackUpArray.count!=0) {
        
        if (chatIndex!=10000) {
            NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
            NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
            [fetch setEntity:productEntity];
            NSPredicate *p=[NSPredicate predicateWithFormat:@"groupId == %@", [NSNumber numberWithInt:chatCount]];
            [fetch setPredicate:p];
            NSError *fetchError;
            NSError *error;
            NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
            for (NSManagedObject *product in fetchedProducts) {
                [self.managedObjectContext deleteObject:product];
                
                
            }
            [self.managedObjectContext save:&error];

        }
        
        NSData *chatData=[NSKeyedArchiver archivedDataWithRootObject:chatBackUpArray];
        NSString *chatString=[chatData base64EncodedStringWithOptions:0];
        
        Group *group=(Group *)[NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
        [group setGroupId:[NSNumber numberWithInt:chatCount]];
        [group setGroupChat:chatString];
        [group setBookmark:[NSNumber numberWithInt:bookmarkSelected]];
        [group setBookmarkname:bookmarknamefield.text];
   
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Failed to save: %@", [error userInfo]);
        } else {
            NSLog(@"saved Successfully");
        }
    }
    
   // [self.firebase removeValue];
    [self.delegate dismissChatViewController];
}

-(void)loadOptionsPane{
     NSArray *optionsNamesArray=[[NSArray alloc]initWithObjects:@"Record", @"Draw", @"Social", @"Meetings",@"People",@"Bookmark", nil];
    NSArray *optionsImagesArray=[[NSArray alloc]initWithObjects:@"microphone_record.png",@"draw.png",@"social.png",@"calendar.png",@"meeting.jpg",@"bookmark.png", nil];
    
    int xCoordinate=20, yCoordinate=15;
    for (int i=0; i<6; i++) {
        UIView *oView=[[UIView alloc]initWithFrame:CGRectMake(xCoordinate, yCoordinate, 73, 80)];
        oView.tag=i;
       // [oView setBackgroundColor:[UIColor lightGrayColor]];
        oView.layer.cornerRadius=6.0;
        
        UIButton *oButton;
        if (i==0 || i==2) {
            oButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 53, 60)];
        }
        else
            oButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 73, 60)];
        oButton.tag=i;
        //[oButton setTitle: forState:UIControlStateNormal];
        [oButton addTarget:self action:@selector(showSpecificOption:) forControlEvents:UIControlEventTouchUpInside];
        [oButton setBackgroundImage:[UIImage imageNamed:[optionsImagesArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 73, 20)];
        [label setText:[optionsNamesArray objectAtIndex:i]];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        label.textAlignment=NSTextAlignmentCenter;
        
        [oView addSubview:oButton];
        [oView addSubview:label];
        [optionsView addSubview:oView];
        
        xCoordinate+=93;
        
        if ((i+1)%3==0) {
            xCoordinate=15;
            yCoordinate+=95;
        }
        
    }
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 200, 300, 40)];
    [cancelButton setTitle:@"Cancel Button" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideOptionsPane) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    
    [optionsView addSubview:cancelButton];
}

-(void)showSpecificOption:(UIButton*)sender{

    [chatTextView resignFirstResponder];
    
    if (sender.tag==1) {
        [self realTimeDraw];
    }
    else if (sender.tag==2) {
        [self socialSharing];
    }
    else if (sender.tag==3) {
        //Meeting;
        NSLog(@"here");
        [self hideOptionsPane];
        

        CalendarViewController *controller=[[CalendarViewController alloc]init];
        //[navigationController pushViewController:controller animated:YES];
        //[self.navigationController pushViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
        

    }
    else if(sender.tag==5){
        if (bookmarkSelected==0) {
            [sender setBackgroundImage:[UIImage imageNamed:@"bookmark1.png"] forState:UIControlStateNormal];
            bookmarkSelected=1;
            UIAlertView *alert = [[UIAlertView alloc] init];
            
            alert.title = @"Please give a name for the pin";
            
            alert.message = nil;
            
            alert.delegate = self;
            [alert addButtonWithTitle:@"Cancel"];
            [alert addButtonWithTitle:@"OK"];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
           bookmarknamefield=[alert textFieldAtIndex:0];
            
            
            [alert show];

            //[self.firebase removeValue];
        }
        else{
            [sender setBackgroundImage:[UIImage imageNamed:@"bookmark.png"] forState:UIControlStateNormal];
            bookmarkSelected=0;
            bookmarknamefield.text=@"";
        }
    }
        NSLog(@"%d",(int)sender.tag);
}

-(void)socialSharing{
    [self hideOptionsPane];
    
    UIButton *twitterButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.jpg"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    twitterButton.layer.cornerRadius=6.0f;
    twitterButton.layer.masksToBounds=YES;
    twitterButton.tag=1;
    
    UIButton *facebookButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 20, 60, 60)];
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    facebookButton.layer.cornerRadius=6.0f;
    facebookButton.layer.masksToBounds=YES;
    facebookButton.tag=2;
    
    UIButton *emailButton=[[UIButton alloc]initWithFrame:CGRectMake(180, 30, 60, 40)];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"mailicon.png"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    emailButton.layer.cornerRadius=6.0f;
    emailButton.layer.masksToBounds=YES;
    emailButton.tag=3;
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(240, 0, 20, 20)];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton addTarget:self action:@selector(socialButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_delete@2x.png"] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius=6.0f;
    cancelButton.layer.masksToBounds=YES;
    cancelButton.tag=4;
    
    socialNetworkView=[[UIView alloc]initWithFrame:CGRectMake(30, 1000, 260, 110)];
    //[socialNetworkView setBackgroundColor:[UIColor colorWithRed:245.0 green:242.0 blue:237.0 alpha:0.0]];
    socialNetworkView.layer.cornerRadius=8.0f;
    socialNetworkView.layer.masksToBounds=YES;
    [socialNetworkView setClipsToBounds:YES];
    [socialNetworkView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    
    [socialNetworkView addSubview:twitterButton];
    [socialNetworkView addSubview:facebookButton];
    [socialNetworkView addSubview:emailButton];
    [socialNetworkView addSubview:cancelButton];
    [self.view addSubview:socialNetworkView];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        socialNetworkView.frame=CGRectMake(30, 100, 260, 110);
    }];
}

-(void)socialButtonTapped:(UIButton*)sender{
    if (sender.tag==1){
        [self twitterPost];
    }
    else if (sender.tag==2){
        [self facebookPost];
    }
    else if (sender.tag==3){
        [self sendEmail];
    }
    else if (sender.tag==4){
        [UIView animateWithDuration:0.5 animations:^(void){
            socialNetworkView.frame=CGRectMake(30, 1000, 260, 110);
            socialNetworkView=nil;
        }];
    }
}


-(void)facebookPost{
    
    UIImage *newScreenshot=[self getScreenShot];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookPost setInitialText:@""];
        [facebookPost addImage:newScreenshot];
        [facebookPost addURL:[NSURL URLWithString:@"www.facebook.com"]];
        [self presentViewController:facebookPost animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)twitterPost{
    UIImage *newScreenshot=[self getScreenShot];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet addImage:newScreenshot];
        [tweetSheet setInitialText:@""];
        [tweetSheet addURL:[NSURL URLWithString:@"www.twitter.com"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)sendEmail{
    UIImage *newScreenshot=[self getScreenShot];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.view.frame=CGRectMake(0, 0, 320, 568-44);
    [picker setSubject:@"set subject"];
    [picker setTitle:@"Email"];
    [picker.navigationBar setTintColor:[UIColor colorWithRed:(float)214/255 green:(float)88/255 blue:(float)94/255 alpha:1]];
    [picker addAttachmentData:UIImagePNGRepresentation(newScreenshot) mimeType:@"png" fileName:[NSString stringWithFormat:@"test.png"]];
    [picker setToRecipients:[NSArray array]];
    [picker setMessageBody:@"set body" isHTML:YES];
    [picker setMailComposeDelegate:self];
    
    if (picker!=Nil) {
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"No mail account set up yet, cannot mail");
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(UIImage *)getScreenShot{
    CGRect rect=[[UIScreen mainScreen]bounds];
    
    NSMutableArray *screenshots=[[NSMutableArray alloc] initWithObjects: nil];
    UIGraphicsBeginImageContext(rect.size);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect screenshotFrame;
    screenshotFrame.origin.x = 0;
    screenshotFrame.origin.y = 0;
    screenshotFrame.size.height = rect.size.height-44;
    screenshotFrame.size.width =rect.size.width;
    /* Crop the region */
    CGImageRef screenshotRef = CGImageCreateWithImageInRect(viewImage1.CGImage, screenshotFrame);
    UIImage * screenshot = [UIImage imageWithCGImage:screenshotRef];
    
    
    CFRelease(screenshotRef);
    if (screenshot!=Nil) {
        [screenshots addObject:screenshot];
    }else{
        
    }
    return screenshot;
}


-(void)showOptionsPane{
    optionsView.hidden=NO;
    [UIView animateWithDuration:0.5 animations:^{
        optionsView.frame=CGRectMake(10, 174, 300, 240);
    }];
    [self.view bringSubviewToFront:optionsView];
}

-(void)hideOptionsPane{
    //optionsView.hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
        optionsView.frame=CGRectMake(10, 568, 300, 240);
    }];
}

-(void)realTimeDraw{
    [self hideOptionsPane];
    
    fdViewController=[[FDViewController alloc]init];
    fdViewController.delegate=self;
    
    [UIView animateWithDuration:0.5 animations:^{
        fdViewController.view.frame=CGRectMake(0, 0, 320, 558);
    }];
    

    [self presentViewController:fdViewController animated:YES completion:nil];
//    optionsButton.hidden=YES;
//    endChatButton.hidden=YES;
//    chatView.hidden=YES;
//    
//     UIImage *buttonBackgroundImage = [UIImage imageNamed:@"greyButton.png"];
//    
//    realTimeMainView=[[UIView alloc]initWithFrame:CGRectMake(-320, 0, 320, 568)];
//    
//    UIButton *useButton=[[UIButton alloc]initWithFrame:CGRectMake(250, 30, 50, 30)];
//    [useButton setTitle:@"Use" forState:UIControlStateNormal];
//    [useButton addTarget:self action:@selector(hideRealTimeViewAndCapture) forControlEvents:UIControlEventTouchUpInside];
//    [useButton setBackgroundImage:[buttonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(21.0, 21.0, 21.0, 21.0)] forState:UIControlStateNormal];
//    [useButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    
//    bounds=[[UIScreen mainScreen]bounds];
//    
////    imageView=[[UIImageView alloc]init];
////    imageView.frame=CGRectMake(0, 30, bounds.size.width, bounds.size.height-74);
//    
//    tempImageView=[[UIImageView alloc]init];
//    
//    colorsView=[[UIView alloc]initWithFrame:CGRectMake(10, 568-74, 300, 74)];
//    [colorsView setBackgroundColor:[UIColor lightGrayColor]];
//    colorsView.layer.cornerRadius=8.0;
//    colorsView.userInteractionEnabled=YES;
//    
//    colorScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 74)];
//    [colorScrollView setDelegate:self];
//    colorScrollView.scrollEnabled=YES;
//    colorScrollView.showsHorizontalScrollIndicator = YES;
//    colorScrollView.userInteractionEnabled=YES;
//    
//    NSArray *colorsArray=[[NSArray alloc]initWithObjects:[UIColor greenColor],[UIColor magentaColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor clearColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],nil];
//    
//    float x=10.0;
//    for (int i=0; i<10; i++) {
//        UIButton *colorButton=[[UIButton alloc]initWithFrame:CGRectMake(x, 15, 40, 44)];
//        colorButton.tag=i;
//        //[colorButton setBackgroundColor:[UIColor redColor]];
//        [colorButton setBackgroundColor:[colorsArray objectAtIndex:i]];
//        [colorButton addTarget:self action:@selector(colorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [colorScrollView addSubview:colorButton];
//        colorButton.layer.cornerRadius=6.0;
//        x=x+60.0;
//    }
//    colorScrollView.contentSize=CGSizeMake(x+65.0, 74.0);
//    
//    [realTimeMainView addSubview:useButton];
//  //  [realTimeMainView addSubview:imageView];
//  //  [realTimeMainView addSubview:tempImageView];
//    [realTimeMainView addSubview:colorsView];
//    [colorsView addSubview:colorScrollView];
//    [self.view addSubview:realTimeMainView];
//    [realTimeMainView addSubview:self.drawView];
    
   }

-(void)hideRealTimeViewAndCaptureWithImage:(UIImage *)image{
    
   // UIImage* image=[self getScreenShot];
    
   
    
    
    NSString *string=[self imageToNSString:image];
    
    NSLog(@"%d",string.length);
    
    NSString *encodeString=[@"abcd" stringByAppendingString:string];
    
    [[self.firebase childByAutoId] setValue:@{@"name" : [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"], @"text": encodeString}];
    
    [UIView animateWithDuration:0.5 animations:^{
        [fdViewController dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished){
        fdViewController=nil;
//       c UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
//        [img setImage:image];
//        [self.view addSubview:img];
    }];
}


- (NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    touchMoved = NO;
//    UITouch *touch = [touches anyObject];
//    lastPoint = [touch locationInView:imageView];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    touchMoved = YES;
//    UITouch *touch = [touches anyObject];
//    CGPoint currentPoint = [touch locationInView:imageView];
//    
//    UIGraphicsBeginImageContext(imageView.frame.size);
//    //CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
//    [tempImageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
//    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//    
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    [tempImageView setAlpha:opacity];
//    UIGraphicsEndImageContext();
//    
//    UIGraphicsBeginImageContext(imageView.frame.size);
//    // CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    [tempImageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    tempImageView.image = nil;
//    UIGraphicsEndImageContext();
//    
//    lastPoint = currentPoint;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if(!touchMoved) {
//        UIGraphicsBeginImageContext(imageView.frame.size);
//        [tempImageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//        //  CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        CGContextFlush(UIGraphicsGetCurrentContext());
//        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    
//    UIGraphicsBeginImageContext(imageView.frame.size);
//    //CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    [tempImageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    tempImageView.image = nil;
//    UIGraphicsEndImageContext();
//}
//


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
