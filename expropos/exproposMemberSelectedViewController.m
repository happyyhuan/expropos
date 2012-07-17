//
//  exproposMemberSelectedViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMemberSelectedViewController.h"
#import "ExproMember.h"
#import "NSDictionary+mutableDeepCopy.h"
#import "ExproUser.h"
#import "ExproRole.h"
#import "ExproMerchant.h"
#import "RestKit/RestKit.h"
#import "exproposDealSelectedViewController.h"
#import "RestKit/CoreData.h"
#import "exproposAppDelegate.h"
#import "exproposDealOperateViewController.h"
#import "ExproMultipleTableView.h"
#import "exproposDealOperateMenuViewController.h"

@interface exproposMemberSelectedViewController ()

@end

@implementation exproposMemberSelectedViewController
@synthesize allMembers = _allMembers;
@synthesize members = _members;
@synthesize memberTypes = _memberTypes;
@synthesize searchBar = _searchBar;
@synthesize updateTime = _updateTime;
@synthesize viewController = _viewController;
@synthesize freshButton = _freshButton;
@synthesize sysLoad = _sysLoad;
@synthesize  popover = _popover;

-(void)awakeFromNib
{
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

-(void)loadData
{
    ExproMerchant *merchant = nil;
    exproposAppDelegate *appdelegate = [[UIApplication sharedApplication] delegate  ];
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appdelegate.currentUser.gid){
            merchant = member.org;
        }
    }
     //初始化会员选择数据
     
     NSSet *alls =  merchant.members;
    NSArray *roles = [ExproRole findAll];
    
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:100];
    for(ExproRole *role in roles){
        if([role.name isEqualToString:@"商户业主"]||[role.name isEqualToString:@"商户收银员"]){
            continue;
        }
        
        NSMutableArray *tmpMembers = [[NSMutableArray alloc]initWithCapacity:20];
        for(ExproMember *m in alls){
            if(m.role.gid.intValue == role.gid.intValue){
                [tmpMembers addObject:m];
            }
        }
        
        if([tmpMembers count]>0){
            [dic setObject:tmpMembers forKey:role.name];
        }
    }
    
    self.allMembers = [NSDictionary dictionaryWithDictionary:dic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.searchBar.keyboardType = UIKeyboardTypePhonePad;
    
    [self loadData];
    
    
    [self restSearch];
    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    
    self.updateTime.title = currentDateStr;
    self.updateTime.width = 250;
    self.updateTime.Enabled = NO;
}

- (void)viewDidUnload
{
    self.allMembers =nil;
    self.members = nil;
    self.memberTypes = nil;
    self.searchBar = nil;
    self.updateTime = nil;
    [self setFreshButton:nil];
    [super viewDidUnload];
}

#pragma mark -

#pragma mark search methods
-(void)restSearch
{
    self.members = [self.allMembers mutableDeepCopy];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[self.allMembers allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.memberTypes = array;
}

-(void)searchMember:(NSString*)telnum
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self restSearch];
    
    for(NSString *key in self.memberTypes){
        NSMutableArray *array = [self.members valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
       for(ExproMember* member in array){
            if([member.user.cellphone rangeOfString:telnum options:NSCaseInsensitiveSearch].location == NSNotFound){
                [toRemove addObject:member];
            }
       }
        
        if([array count]==[toRemove count]){
            [sectionsToRemove addObject:key];
        }
               
        [array removeObjectsInArray:toRemove];
    }
    [self.memberTypes removeObjectsInArray:sectionsToRemove];
    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate Method
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length]==0){
        [self restSearch];
        [self.tableView reloadData];
        return;
    }
    [self searchMember:searchText];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self restSearch];
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchMember:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - 


#pragma mark - Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = ([self.memberTypes count]>0)? [self.memberTypes count]:1;
    return  sections+1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    
    if([self.memberTypes count]==0){
        return 0;
    }
    NSString *memberType = [self.memberTypes objectAtIndex:section-1];
    NSArray *memberSection = [self.members objectForKey:memberType];
    return [memberSection count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"memberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = indexPath.row;
    
    if(section == 0){
        if([self.viewController isKindOfClass:[exproposDealSelectedViewController class]]){
            exproposDealSelectedViewController *deal = (exproposDealSelectedViewController *)self.viewController;
            cell.textLabel.text = @"所有会员";
            cell.detailTextLabel.text = @"";
            if(deal.members.count ==0 ){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        }
        if([self.viewController isKindOfClass:[exproposDealOperateViewController class]]){
            cell.textLabel.text = @"请选择会员";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = @"";
            return cell;
        }
    }
    
    NSString *memberType = [self.memberTypes objectAtIndex:section-1];
    NSArray *memberSection = [self.members objectForKey:memberType];
    ExproMember *member = [memberSection objectAtIndex:row];
    
    cell.textLabel.text = member.petName;
    cell.detailTextLabel.text = member.user.cellphone;
    cell.imageView.image = [UIImage imageNamed:@"member.png"];
    
    if([self.viewController isKindOfClass:[exproposDealSelectedViewController class]]){
        exproposDealSelectedViewController *deal = (exproposDealSelectedViewController *)self.viewController;
        if([self array:deal.members contain:member]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if([self.viewController isKindOfClass:[exproposDealOperateViewController class]]){
        exproposDealOperateViewController *dealOperate = (exproposDealOperateViewController *)self.viewController;
            
           if(dealOperate.member!=nil && dealOperate.member.gid.intValue == member.gid.intValue){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        
    }


    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([self.memberTypes count]==0){
        return @"";
    }
    if(section == 0){
        return @"";
    }
    NSString *memberType = [self.memberTypes objectAtIndex:section-1];
    return memberType;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger section = indexPath.section;
    
    
    if(section == 0){
        cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        if([self.viewController isKindOfClass:[exproposDealSelectedViewController class]]){
            exproposDealSelectedViewController *deal = (exproposDealSelectedViewController *)self.viewController;
            [deal.members removeAllObjects];
            [deal.tableView reloadData];
        }
        if([self.viewController isKindOfClass:[exproposDealOperateViewController class]]){
            cell0.accessoryType = UITableViewCellAccessoryNone;
            return;
        }
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    NSInteger row = indexPath.row;
    NSString *memberType = [self.memberTypes objectAtIndex:section-1];
    NSArray *memberSection = [self.members objectForKey:memberType];
    ExproMember *member = [memberSection objectAtIndex:row];
    if([self.viewController isKindOfClass:[exproposDealSelectedViewController class]]){
        exproposDealSelectedViewController *deal = (exproposDealSelectedViewController *)self.viewController;
        if([self array:deal.members contain:member] ){
            [deal.members removeObject:member];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if(deal.members.count == 0){
                cell0.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }else {
            [deal.members addObject:member];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell0.accessoryType = UITableViewCellAccessoryNone;
        }
         [deal.tableView reloadData];
    }
    if([self.viewController isKindOfClass:[exproposDealOperateViewController class]]){
        exproposDealOperateViewController *dealOperate = (exproposDealOperateViewController *)self.viewController;
        if(dealOperate.member != nil && dealOperate.member.gid.intValue == member.gid.intValue){
            dealOperate.member = nil;
        }else {
            dealOperate.member = member;
        }
        [self.tableView reloadData];
        
        [dealOperate.dealOperateMenu.menuTableView reloadData];
        [dealOperate.mySelectedGoods removeAllObjects];
        [dealOperate.goodsAndAmount removeAllObjects];
        dealOperate.deal = nil;
        [dealOperate.dealItemTableView reloadData];
        //[dealOperate addToolBarItem];
        [_popover dismissPopoverAnimated:YES];
    }
    
}

-(BOOL)array:(NSArray*)array contain:(ExproMember *)member
{
    for(ExproMember *m in array){
        if(m == member){
            return YES;
        }
    }
    return NO;
}


- (IBAction)update:(UIBarButtonItem *)sender {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("informations downloader", NULL);
    dispatch_async(downloadQueue, ^{
        _sysLoad = [[exproposSysLoad alloc]init];
        _sysLoad.reserver = self;
        _sysLoad.succeedCallBack = @selector(updateSuccess);
        exproposAppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        NSString *gidstr = [NSString stringWithFormat:@"%qu",appdelegate.currentUser.gid.unsignedLongLongValue];
        [_sysLoad loadSysData:gidstr  completion:nil];
    });
    dispatch_release(downloadQueue);    
}

-(void)updateSuccess
{
    self.navigationItem.rightBarButtonItem = _freshButton;
    [self loadData];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    
    self.updateTime.title = currentDateStr;
    [self.tableView reloadData];
}
@end