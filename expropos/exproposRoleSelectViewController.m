//
//  exproposRoleSelectViewControllerViewController.m
//  expropos
//
//  Created by chen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposRoleSelectViewController.h"
#import "ExproRole.h"

@implementation exproposRoleSelectViewController

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
    NSArray *roles = [ExproRole findAll];
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i =0;i<roles.count;i++)
    {
        ExproRole *role = [roles objectAtIndex:i];                
        [names addObject:role.name];
    }
    [self setLevelItem:names];
    //_levelItem = [NSArray arrayWithObjects:@"不开放",@"基本信息开放",@"完全开放", nil];
    self.navigationItem.title = @"选择资料开放权限";
    UITableView* tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableview;
    self.contentSizeForViewInPopover = CGSizeMake(300, 550);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.levelItem = nil;
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
        cell.textLabel.text = @"权限开放";
        if(self.viewController.privacyItem.count == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        return cell;
    }
    
    
    cell.textLabel.text = [self.levelItem objectAtIndex:indexPath.row];
    if([self.viewController.privacyItem containsObject:[NSNumber numberWithInt:indexPath.row]]){
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
        //[self.viewController.privacyItem removeAllObjects];
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.viewController.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    [self.viewController.privacyItem removeAllObjects];
    [self.viewController.privacyItem addObject:[NSNumber numberWithInt:indexPath.row]];
    cell0.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;    [self.viewController.tableView reloadData];
    [self viewDidLoad];
}


@end