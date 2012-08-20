//
//  storeSelectViewController.m
//  expropos
//
//  Created by chen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "storeSelectViewController.h"
#import "ExproStore.h"
#import "exproposAppDelegate.h"
#import "ExproMerchant.h"

@interface storeSelectViewController ()

@end

@implementation storeSelectViewController

@synthesize viewController = _viewController;
@synthesize storeItem = _storeItem;
@synthesize allStoreItem =_allStoreItem;
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
    exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *orgId = appDelegate.currentOrgid ;
    
    //查找当前商户信息
    NSFetchRequest *request = [ExproMerchant fetchRequest];
    NSPredicate *predicate = nil;
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
    NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:orgId, nil];
//    request.sortDescriptors = [[NSArray alloc]initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"signintime" ascending:NO], nil];

    predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
    NSLog(@"%@",predicate);
    request.predicate = predicate;
    NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
    
    
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i =0;i<merchants.count;i++)
    {
        ExproMerchant *merchant = [merchants objectAtIndex:i];  
        NSSet *stores = merchant.stores;
        for(ExproStore *item in stores){
            NSLog(@"%@",item.name);
            [names addObject:item.name]; 
        }
    }
    [self setStoreItem:names];
   
    self.navigationItem.title = @"选择门店";
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableview;
    self.contentSizeForViewInPopover = CGSizeMake(300, 550);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.storeItem = nil;
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
        return [self.storeItem count];
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
        cell.textLabel.text = @"请选择门店";
        if(self.viewController.storeSelItem.count == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }    
    cell.textLabel.text = [self.storeItem objectAtIndex:indexPath.row];
    if([self.viewController.storeSelItem containsObject:[self.storeItem objectAtIndex:indexPath.row]]){
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
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.viewController.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    [self.viewController.storeSelItem removeAllObjects];
    [self.viewController.storeSelItem addObject:[self.storeItem objectAtIndex:indexPath.row]];
    cell0.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;    [self.viewController.tableView reloadData];
    [self viewDidLoad];
}


@end