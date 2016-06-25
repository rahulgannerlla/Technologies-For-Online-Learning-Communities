//
//  GroupsViewController.m
//  TOLC2
//
//  Created by Rahul Gannerlla on 10/14/14.
//  Copyright (c) 2014 Sachit Dhal. All rights reserved.
//

#import "GroupsViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController
@synthesize sortedKeys;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    fetchResults=[[NSArray alloc]init];
    self.title=@"Chat";
    self.sortedKeys =[[NSArray alloc]
                      initWithObjects:@"Maths",@"Biology",@"Programming",nil];

    mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, 510) style:UITableViewStyleGrouped];
    
    
    [self.view addSubview:mainTableView];
    
    [self fetchData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self fetchData];
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
            mainTableView.delegate=self;
            mainTableView.dataSource=self;
        }
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   
    
    return 1;
}
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sortedKeys objectAtIndex:section];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return fetchResults.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    }
    cell.textLabel.text=[NSString stringWithFormat:@"chat %d",(int)indexPath.row];
    NSUInteger r = arc4random_uniform(5);
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d new updates",r];

    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Group *selectedGroup=[fetchResults objectAtIndex:indexPath.row];
    
    detailedViewController=[[ChatViewController alloc]initWithIndex:[selectedGroup.groupId intValue]];
    detailedViewController.delegate =self;
    detailedViewController.managedObjectContext=self.managedObjectContext;
    [self presentViewController:detailedViewController animated:YES completion:nil];
  //  [self.navigationController pushViewController:detailedViewController animated:YES];
}

-(void)dismissChatViewController{
    [detailedViewController dismissViewControllerAnimated:YES completion:nil];
    detailedViewController=nil;
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
