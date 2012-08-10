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
#import "exproposShowDealOperateViewController.h"

@interface exproposMenuViewController ()

@end

@implementation exproposMenuViewController
@synthesize menus = _menus;
@synthesize mainViewController = _mainViewController;
@synthesize showDeal   =  _showDeal;
@synthesize controllers = _controllers;
@synthesize memberRegister = _memberRegister;
@synthesize dealOperate = _dealOperate;
@synthesize storeControll =_storeControll;
@synthesize memberManagerControll =_memberManagerControll;
@synthesize goodsManager = _goodsManager;
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
    //初始化菜单数组显示的内容
    self.menus = [NSArray arrayWithObjects:@"门店管理", @"会员管理", @"商品管理", @"交易查询", @"会员开户", nil];
    //初始化主窗体控制器
    self.mainViewController = [self.splitViewController.viewControllers lastObject];
    //初始化交易查询控制器
    _showDeal = [self.storyboard instantiateViewControllerWithIdentifier:@"showDeals"];
     //初始化交易处理控制器
     _dealOperate = [self.storyboard instantiateViewControllerWithIdentifier:@"dealOperateVersion2"];
    //初始化需要加入到主窗体的view的控制器数组
    _controllers = [[NSMutableArray alloc]initWithCapacity:20];
    
    _memberRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    
       _storeControll = [self.storyboard instantiateViewControllerWithIdentifier:@"storeManager"];
    _memberManagerControll = [self.storyboard instantiateViewControllerWithIdentifier:@"memberManager"];
    
     _goodsManager = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsManager"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _showDeal = nil;
    _controllers = nil;
    _dealOperate = nil;
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
        //当切换到交易查询view之前，需要将原来主窗体上的view移出
        for(UIViewController *contro in _controllers){
            [contro.view removeFromSuperview];
        }
        [_controllers addObject:_showDeal];
        //设置交易查询view，在主窗体上显示的frame
        _showDeal.view.frame = CGRectMake(0, 44, self.mainViewController.view.bounds.size.width, self.mainViewController.view.bounds.size.height);
        //将主窗体对象传递给交易查询控制器的属性对象
        _showDeal.mainViewController = self.mainViewController;
        
        [self.mainViewController.view addSubview: _showDeal.view];
        //如果是竖屏情况，将隐藏左侧菜单栏
        [self.mainViewController.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    if([menu isEqualToString:@"门店管理"]){
        //如果是竖屏情况，将隐藏左侧菜单栏
         [_mainViewController.masterPopoverController dismissPopoverAnimated:YES];
        _storeControll.myRootViewController = self.splitViewController;
       [self.splitViewController presentModalViewController:_storeControll animated:YES];
           
    }   
    
    if([menu isEqualToString:@"会员开户"]){
        for(UIViewController *contro in _controllers){
            [contro.view removeFromSuperview];
        }
        [_controllers addObject:_memberRegister];
        _memberRegister.view.frame = CGRectMake(0, 44, self.mainViewController.view.bounds.size.width, self.mainViewController.view.bounds.size.height);
        _memberRegister.mainViewController = self.mainViewController;
        [self.mainViewController.view addSubview: _memberRegister.view];
        
        //        [_mainViewController.masterPopoverController dismissPopoverAnimated:YES];
        //        _memberManagerControll.myRootViewController = self.mainViewController;
        //        [self.splitViewController presentModalViewController:_memberManagerControll animated:YES];
    }
    
    if([menu isEqualToString:@"会员管理"]){
 
        [_mainViewController.masterPopoverController dismissPopoverAnimated:YES];
        _memberManagerControll.myRootViewController = self.mainViewController;
        [self.splitViewController presentModalViewController:_memberManagerControll animated:YES];
    }  
    
    if([menu isEqualToString:@"商品管理"]){
        //如果是竖屏情况，将隐藏左侧菜单栏
        [_mainViewController.masterPopoverController dismissPopoverAnimated:YES];
        _goodsManager.myRootViewController = self.splitViewController;
        [self.splitViewController presentModalViewController:_goodsManager animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } 
}



@end
