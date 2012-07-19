//
//  exproposMenuViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMenuViewController.h"
#import "exproposDealSelectedViewController.h"
#import "exproposAppDelegate.h"

@interface exproposMenuViewController ()

@end

@implementation exproposMenuViewController
@synthesize menus = _menus;
@synthesize mainViewController = _mainViewController;
@synthesize showDeal   =  _showDeal;
@synthesize dealoperate = _dealoperate;
@synthesize controllers = _controllers;
@synthesize memberRegister = _memberRegister;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

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
    self.menus = [NSArray arrayWithObjects:@"消费", @"充值", @"积分", @"交易查询", @"会员开户", nil];

    self.mainViewController = [self.splitViewController.viewControllers lastObject];
    _showDeal = [self.storyboard instantiateViewControllerWithIdentifier:@"showDeals"];
    _controllers = [[NSMutableArray alloc]initWithCapacity:20];
    
    _memberRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _showDeal = nil;
    _dealoperate = nil;
    _controllers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.menus objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    NSString *menu = [self.menus objectAtIndex:row];
    if([menu isEqualToString:@"交易查询"]){
        for(UIViewController *contro in _controllers){
            [contro.view removeFromSuperview];
        }
        [_controllers addObject:_showDeal];
        _showDeal.view.frame = CGRectMake(0, 44, self.mainViewController.view.bounds.size.width, self.mainViewController.view.bounds.size.height);
        _showDeal.mainViewController = self.mainViewController;
        
        [self.mainViewController.view addSubview: _showDeal.view];
        [self.mainViewController.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    if([menu isEqualToString:@"消费"]){
        exproposShowDealsSelectedViewController *dealOperate = [self.storyboard instantiateViewControllerWithIdentifier:@"dealOperateVersion2"];
        exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = dealOperate;
    }
   

    
    if([menu isEqualToString:@"会员开户"]){
        for(UIViewController *contro in _controllers){
            [contro.view removeFromSuperview];
        }
        [_controllers addObject:_memberRegister];
        _memberRegister.view.frame = CGRectMake(0, 44, self.mainViewController.view.bounds.size.width, self.mainViewController.view.bounds.size.height);
        _memberRegister.mainViewController = self.mainViewController;
        
        [self.mainViewController.view addSubview: _memberRegister.view];
        [self.mainViewController.masterPopoverController dismissPopoverAnimated:YES];
        
//        
//        _memberRegister.view.frame = CGRectMake(0, 44, self.mainViewController.view.bounds.size.width, self.mainViewController.view.bounds.size.height);
//        //_memberRegister.viewController = self.mainViewController;
//        
//        [self.mainViewController.view insertSubview:_memberRegister.view atIndex:0];
    }   
}



@end
