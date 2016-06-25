//
//  DetailedChatViewController.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 11/4/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "DetailedChatViewController.h"

@interface DetailedChatViewController ()

@end

@implementation DetailedChatViewController

-(id)initWithGroup:(Group *)group{
    self=[super init];
    
    selectedGroup=group;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.navigationController.navigationItem
    
    y=10;
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chatbg.png"]]];
    
    chatScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-65)];
    [chatScrollView setScrollEnabled:YES];
    chatScrollView.delegate=self;
    
    [self.view addSubview:mainView];
    [mainView addSubview:chatScrollView];
    // Do any additional setup after loading the view.
    [self loadContent];
    
}

-(void)loadContent{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:selectedGroup.groupChat options:0];
    
    NSMutableArray *chatArray=[NSKeyedUnarchiver unarchiveObjectWithData:nsdataFromBase64String];
    
    for (int i=0; i<chatArray.count; i++) {
        
        NSDictionary *chatDic=chatArray[i];
        UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(10, y, 0, 0)];
        tempView.layer.cornerRadius=4.0;
        [tempView setBackgroundColor:[UIColor whiteColor]];
        
        NSString *chatString=[NSString stringWithFormat:@"%@ - %@",chatDic[@"name"],chatDic[@"text"]];
        
        UILabel *chatLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
        [chatLabel setText:chatString];
        [chatLabel sizeToFit];
        [chatLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
        [chatLabel setTextColor:[UIColor blackColor]];
        
        if([chatDic[@"name"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]])
            tempView.frame=CGRectMake(10, y, chatLabel.frame.size.width, chatLabel.frame.size.height);
        else
            tempView.frame=CGRectMake(240, y, 80, chatLabel.frame.size.height);
        
        y=y+30;
        [tempView addSubview:chatLabel];
        [chatScrollView addSubview:tempView];
        
    }

    [chatScrollView setContentSize:CGSizeMake(320, y)];
    //[chatScrollView scrollRectToVisible:CGRectMake(0, y-320, 320, 320) animated:YES];
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
