//
//  HistoryViewController.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 11/3/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

-(id)init{
    if(self==[super init]){
        self.title=@"Bookmark";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    selectedResults=[[NSMutableArray alloc]init];
    fetchResults=[[NSArray alloc]init];
    
//    segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"History",@"Bookmarks", nil]];
//    segmentedControl.frame=CGRectMake(50, 60, 220, 30);
//    [segmentedControl addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
//    [segmentedControl setSelectedSegmentIndex:0];
//    
    
    
    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 490) style:UITableViewStyleGrouped];
    
  //  [self.view addSubview:segmentedControl];
    [self.view addSubview:mainTableView];
    
    [self fetchData];
    [self loadDataIntoTable:1];
    
//    [self.view bringSubviewToFront:segmentedControl];
//    [mainTableView bringSubviewToFront:segmentedControl];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self fetchData];
    [self loadDataIntoTable:1];
}

-(void)segmentedChanged:(UISegmentedControl*)newSegmentedControl{
    //[];
    if (newSegmentedControl.selectedSegmentIndex==0) {
        [self loadDataIntoTable:0];
    }
    else
       [self loadDataIntoTable:1];
    
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
        NSLog(@"Error When Fetching Cartridge: %@", error.userInfo);
    } else {
        if ([fetchResults count] > 0) {
        }
    }
}

-(void)loadDataIntoTable:(int)index{
    [selectedResults removeAllObjects];
    for (Group *group in fetchResults) {
        if([group.bookmark intValue]==index)
           [selectedResults addObject:group];
    }
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    [mainTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return selectedResults.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        //        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
//    if(segmentedControl.selectedSegmentIndex==0)
    cell.textLabel.text= [[selectedResults objectAtIndex:(int)indexPath.row] valueForKey:@"bookmarkname"];
;
//    else
//    cell.textLabel.text=[NSString stringWithFormat:@"bookmark %d",(int)indexPath.row];
    cell.imageView.image=[UIImage imageNamed:@"bookmark1.png"];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Group *group=[selectedResults objectAtIndex:indexPath.row];
    
    
    DetailedChatViewController *detailedViewController=[[DetailedChatViewController alloc]initWithGroup:group];
    
    [self.navigationController pushViewController:detailedViewController animated:YES];
//    NSLog(@"%@",group.groupChat);
//    
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:group.groupChat options:0];
//
//    NSMutableArray *chatArray=[NSKeyedUnarchiver unarchiveObjectWithData:nsdataFromBase64String];
    
    //NSLog(@"%d",chatArray.count);
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
