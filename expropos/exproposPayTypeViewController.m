//
//  exproposPayTypeViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposPayTypeViewController.h"

@interface exproposPayTypeViewController ()

@end

@implementation exproposPayTypeViewController
@synthesize viewController = _viewController;
@synthesize payTypes = _payTypes;

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
    _payTypes = [NSArray arrayWithObjects:@"现金",@"银行卡",@"积分",@"现金+积分",@"银行卡+积分", nil];
    self.navigationItem.title = @"选择结算方式";
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
    self.payTypes = nil;
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
        return [self.payTypes count];
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
        cell.textLabel.text = @"所有结算方式";
        if(self.viewController.payTypes.count == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }
    
    
    cell.textLabel.text = [self.payTypes objectAtIndex:indexPath.row];
    if([self.viewController.payTypes containsObject:[NSNumber numberWithInt:indexPath.row]]){
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
        [self.viewController.payTypes removeAllObjects];
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.viewController.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    
    if( [self.viewController.payTypes containsObject:[NSNumber numberWithInt:indexPath.row]] ){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.viewController.payTypes removeObject:[NSNumber numberWithInt:indexPath.row]];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.viewController.payTypes addObject:[NSNumber numberWithInt:indexPath.row]];
        cell0.accessoryType = UITableViewCellAccessoryNone;
    }
    [self.viewController.tableView reloadData];
}


@end
