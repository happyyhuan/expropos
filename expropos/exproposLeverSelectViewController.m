//
//  exproposLeverSelectViewController.m
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposLeverSelectViewController.h"

@implementation exproposLeverSelectViewController
@synthesize viewController = _viewController;
@synthesize levelItem = _levelItem;

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
    _levelItem = [NSArray arrayWithObjects:@"消费撤",@"消费",@"充值",@"充值撤销",@"积分增加",@"积分消费",@"积分撤销",@"退货退款",@"抽奖",@"手工调整", nil];
    self.navigationItem.title = @"选择交易项目";
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
    self.levelItem = nil;
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
        return [self.levelItem count];
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
        cell.textLabel.text = @"所有交易方式";
        if(self.viewController.levelItem.count == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }
    
    
    cell.textLabel.text = [self.levelItem objectAtIndex:indexPath.row];
    if([self.viewController.levelItem containsObject:[NSNumber numberWithInt:indexPath.row]]){
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
        [self.viewController.levelItem removeAllObjects];
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.viewController.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    
    if( [self.viewController.levelItem containsObject:[NSNumber numberWithInt:indexPath.row]] ){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.viewController.levelItem removeObject:[NSNumber numberWithInt:indexPath.row]];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.viewController.levelItem addObject:[NSNumber numberWithInt:indexPath.row]];
        cell0.accessoryType = UITableViewCellAccessoryNone;
    }
    [self.viewController.tableView reloadData];
}


@end
