//
//  exproposStoreSelectedViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposStoreSelectedViewController.h"
#import "ExproStore.h"
#import "RestKit/RestKit.h"
#import "RestKit/CoreData.h"
#import "ExproMerchant.h"

@interface exproposStoreSelectedViewController ()

@end

@implementation exproposStoreSelectedViewController
@synthesize viewController = _viewController;
@synthesize storeItems = _storeItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _storeItems = [[NSMutableArray alloc]initWithCapacity:20];
  
  /*  NSFetchRequest *request = [ExproMerchant fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %d", @"gid",121212];
    NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
    ExproMerchant *merchant = [merchants objectAtIndex:0];
    NSSet *set = merchant.stores;
    for(ExproStore *store in set){
        [self.storeItems addObject:store];
    }
    */

    NSArray *s = [ExproStore findAll];
    [self.storeItems addObjectsFromArray:s];
    
    self.navigationItem.title = @"选择消费网点";
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableview;
    self.contentSizeForViewInPopover = CGSizeMake(300, 550);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.storeItems = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0 ){
        return 1;
    }else {
        return [self.storeItems count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section == 0){
        cell.textLabel.text = @"所有消费网点";
        if(self.viewController.stores.count == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }
    
    
    cell.textLabel.text = [[self.storeItems objectAtIndex:indexPath.row] name];
    if([self.viewController.stores containsObject: [self.storeItems objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        [self.viewController.stores removeAllObjects];
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.viewController.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    
    if( [self.viewController.stores containsObject:[self.storeItems objectAtIndex:indexPath.row]] ){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.viewController.stores removeObject:[self.storeItems objectAtIndex:indexPath.row]];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.viewController.stores addObject:[self.storeItems objectAtIndex:indexPath.row]];
        cell0.accessoryType = UITableViewCellAccessoryNone;
    }
    [self.viewController.tableView reloadData];
}


@end
