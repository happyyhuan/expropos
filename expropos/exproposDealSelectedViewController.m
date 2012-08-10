//
//  exproposDealSelectedViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposDealSelectedViewController.h"
#import "exproposDateSelectedViewController.h"
#import "exproposMemberSelectedViewController.h"
#import "exproposDealItemSelectedViewController.h"
#import "ExproStore.h"
#import "exproposStoreSelectedViewController.h"
#import "exproposPayTypeViewController.h"
#import "ExproDeal.h"
#import "ExproDealItem.h"
#import "ExproMember.h"
#import "ExproMerchant.h"
#import "RestKit/RestKit.h"
#import "RestKit/CoreData.h"
#import "ExproWarehouseWarrant.h"
#import "exproposUpdateDeals.h"
#import "exproposShowDealsSelectedViewController.h"
#import "NSDate+Helper.h"
#import <Foundation/Foundation.h>

@interface exproposDealSelectedViewController ()

@end

@implementation exproposDealSelectedViewController
@synthesize fromAmoutOfMoney = _fromAmoutOfMoney;
@synthesize endAmoutOfMoney = _endAmoutOfMoney;
@synthesize popover = _popover;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;
@synthesize members = _members;
@synthesize dealItems = _dealItems;
@synthesize stores = _stores;
@synthesize payTypes = _payTypes;
@synthesize update=_update;
@synthesize myPopover=_myPopover;
@synthesize showDeals=_showDeals;
@synthesize deals = _deals;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//交易更新成功后执行该方法
-(void)didUpDataSuccess
{
    [self searchInLoacl];
    _showDeals.data = _deals;
    // 设置动画翻页效果
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    UIView *superView  = _showDeals.tableView.superview;
    
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:_showDeals.tableView cache:YES];
    [_showDeals.tableView removeFromSuperview];
    [superView insertSubview:_showDeals.tableView atIndex:0];
    
    [UIView commitAnimations];
    [_showDeals.tableView reloadData];
    //查询条件过滤弹出框消失
    [self.myPopover dismissPopoverAnimated:YES];
}

//交易查询，先查询本地，然后查询远端服务器
-(void)dealSelect
{
    self.showDeals.dealNum = 0;
    self.showDeals.pageNum = 0;
    self.showDeals.scrollUpdateFlag = YES;
    //本地查询
    [self searchInLoacl];
    
    //本地查询未果，远端查询
    if([_deals count]==0){
        _update = [[exproposUpdateDeals alloc]init];
        _update.reserver = self;
        _update.succeedCallBack = @selector(didUpDataSuccess);
        self.showDeals.pageNum = 1;
        [_update upDateDealStart:0 end:100 bt:self.beginDate et:self.endDate];
        
    }else {//本地查询有结果
        _showDeals.data = _deals;
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        UIView *superView  = _showDeals.tableView.superview;
        
        
        
        
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight forView:_showDeals.tableView cache:YES];
        [_showDeals.tableView removeFromSuperview];
        [superView insertSubview:_showDeals.tableView atIndex:0];
        
        [UIView commitAnimations];
        [_showDeals.tableView reloadData];
        [self.myPopover dismissPopoverAnimated:YES];
    }
}


//安照查询条件进行本地查询
-(void) searchInLoacl
{
    NSFetchRequest *request = [ExproDeal fetchRequest];
    
        
   
   
    NSPredicate *predicate = nil;
    NSLog(@"%@,%@",self.beginDate,self.endDate);
       
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"((createTime >= %@) AND (createTime<= %@ ))" ];
    NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:self.beginDate,self.endDate, nil];
    if(self.payTypes.count >0 ){
        [str appendString:@" AND ( payType IN %@ ) "];
        [params addObject:self.payTypes];
    }
    
    if(self.dealItems.count > 0 ){
        [str appendString:@" AND ( type IN %@ )"];
        [params addObject:self.dealItems];
    }
    
    if(self.fromAmoutOfMoney.length >0 ){
        double amount = self.fromAmoutOfMoney.doubleValue ;
        if(amount!=0){
            [str appendString:@" AND ( payment >= %g )"];
            [params addObject:[NSNumber numberWithDouble:self.fromAmoutOfMoney.doubleValue ]];
        }
    }
    
    if(self.endAmoutOfMoney.length >0 ){
        double amount = self.endAmoutOfMoney.doubleValue ;
        if(amount!=0){
            [str appendString:@" AND ( payment <= %g )"];
            [params addObject:[NSNumber numberWithDouble:self.endAmoutOfMoney.doubleValue ]];
        }
    }
    
    if(self.members.count >0 ){
        [str appendString:@" AND ( customerID IN %@ ) "];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
        for(ExproMember *m in self.members){
            [arr addObject:m.gid];
        }
        [params addObject:arr];
    }
    
    if(self.stores.count >0 ){
        [str appendString:@" AND ( storeID IN %@ ) "];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
        for(ExproStore *s in self.stores){
            [arr addObject:s.gid];
        }
        [params addObject:arr];
    }
    
    predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
    
    NSLog(@"%@",predicate);
    request.sortDescriptors = [[NSArray alloc]initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO], nil];
     request.predicate = predicate;
    [_deals removeAllObjects];
    [_deals addObjectsFromArray:[ExproDeal objectsWithFetchRequest:request]];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(500, 500);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(dealSelect)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSTimeInterval secondsPerDay = 24 * 60 * 60 - 60; 
    _beginDate = [[NSDate date] beginningOfDay];
    //获取时间比真实时间少了8小时，所有手动加上8小时
    _beginDate = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:_beginDate];
    
    _endDate = [[NSDate alloc] initWithTimeInterval:secondsPerDay sinceDate:_beginDate];
    
    _fromAmoutOfMoney = @"";
    _endAmoutOfMoney = @"";
    
    _members = [[NSMutableArray alloc] initWithCapacity:20];
    _dealItems = [[NSMutableArray alloc] initWithCapacity:20];
    _stores = [[NSMutableArray alloc] initWithCapacity:20];
    _payTypes = [[NSMutableArray alloc] initWithCapacity:20];
    _deals = [[NSMutableArray alloc]initWithCapacity:20];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
  /*  self.beginDate = nil;
    self.endDate = nil;
   _fromAmoutOfMoney = nil;
    _endAmoutOfMoney = nil;
   [_members removeAllObjects];
   [_dealItems removeAllObjects];
    [_stores removeAllObjects];
    [_payTypes removeAllObjects];
    [self.tableView reloadData];*/
    [super viewWillDisappear:animated];
}

-(NSDate *)localDate
{
    NSDate *date = [NSDate date];
    date = [[NSDate alloc] initWithTimeInterval:8*60*60 sinceDate:date];
    NSLog(@"localDate:%@",date);
    return date;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2){
        return 4;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dealSelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section ==0 && indexPath.row == 0){
        cell.textLabel.text = @"开始时间";
       
        if([[self dateToString:self.beginDate] isEqualToString: [self dateToString:[self localDate]]]){
            cell.detailTextLabel.text = @"今天";
        }else {
             cell.detailTextLabel.text = [self dateToString:self.beginDate];
        }
    }else if( indexPath.section == 0 && indexPath.row == 1){
        cell.textLabel.text = @"结束时间";
         NSLog(@"beginDate:%@,,,,%@",[self dateToString:self.endDate],[self dateToString:[self localDate]]);
        if( [[self dateToString: [NSDate date]] isEqualToString:  [self dateToString:self.endDate]] ){
            cell.detailTextLabel.text = @"今天";
        }else {
            cell.detailTextLabel.text = [self dateToString:self.endDate];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"金额>";
           cell.detailTextLabel.text = @"";
        
            UITextField *fromAmount = [[UITextField alloc]initWithFrame:CGRectMake(380, 10, 80, 25)];
            [cell addSubview:fromAmount];
            [fromAmount setBackgroundColor:[UIColor whiteColor]];
            fromAmount.borderStyle = UITextBorderStyleLine;
            fromAmount.textAlignment = UITextAlignmentRight;
            fromAmount.text = self.fromAmoutOfMoney;
            fromAmount.tag = 1;
            fromAmount.delegate = self;
            fromAmount.keyboardType = UIKeyboardTypeNumberPad;
            [fromAmount addTarget:self action:@selector(saveFromMenoy:) forControlEvents:UIControlEventEditingChanged];
        }else if(indexPath.row ==1 ){
            cell.textLabel.text = @"金额<";
            cell.detailTextLabel.text = @"";
            UITextField *fromAmount = [[UITextField alloc]initWithFrame:CGRectMake(380, 10, 80, 25)];
            [cell addSubview:fromAmount];
            [fromAmount setBackgroundColor:[UIColor whiteColor]];
            fromAmount.borderStyle = UITextBorderStyleLine;
            fromAmount.textAlignment = UITextAlignmentRight;
            fromAmount.text = self.endAmoutOfMoney;
            fromAmount.tag = 1;
            fromAmount.delegate = self;
            fromAmount.keyboardType = UIKeyboardTypeNumberPad;
            [fromAmount addTarget:self action:@selector(saveEndMenoy:) forControlEvents:UIControlEventEditingChanged];

        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"会员";
            if(self.members.count == 0){
                cell.detailTextLabel.text= @"所有用户";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                for(ExproMember *member in self.members){
                    [message appendFormat:@"%@,",member.petName];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }
          
        }else if(indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"交易项目";
            if(self.dealItems.count == 0){
                cell.detailTextLabel.text= @"所有交易方式";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                NSArray *dealItemTitles = [NSArray arrayWithObjects:@"消费撤",@"消费",@"充值",@"充值撤销",@"积分增加",@"积分消费",@"积分撤销",@"退货退款",@"抽奖",@"手工调整", nil];
                for(NSNumber *i in self.dealItems){
                    [message appendFormat:@"%@,",[dealItemTitles objectAtIndex:i.intValue]];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }

        }else if(indexPath.row ==2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"消费网点";
            if(self.stores.count == 0){
                cell.detailTextLabel.text= @"所有消费网点";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                for(ExproStore *store in self.stores){
                    [message appendFormat:@"%@,",store.name];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }
        }else if(indexPath.row ==3){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"结算方式";
            if(self.payTypes.count == 0){
                cell.detailTextLabel.text= @"所有结算方式";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                NSArray *payTyes = [NSArray arrayWithObjects:@"现金",@"银行卡",@"积分",@"现金+积分",@"银行卡+积分",nil];
                for(NSNumber *i in self.payTypes){
                    [message appendFormat:@"%@,",[payTyes objectAtIndex:i.intValue]];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }
        }

    }
    
    return cell;
}

-(void)saveFromMenoy:(id)sender
{
   UITextField *f = (UITextField *)sender;
    self.fromAmoutOfMoney = f.text;
}
-(void)saveEndMenoy:(id)sender
{
    UITextField *f = (UITextField *)sender;
   
    self.endAmoutOfMoney = f.text;
    
   
}

-(NSString *)dateToString:(NSDate*)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    
    if(indexPath.section == 0){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
        exproposDateSelectedViewController *dateSelect = (exproposDateSelectedViewController *)controller;
        dateSelect.viewController = self;
        if(indexPath.row == 0){
            dateSelect.isBegin = YES;
        }
        if (_popover == nil) {
            _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        }else {
        _popover.contentViewController = controller;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self showOrderNumPopover:cell];
    }else if(indexPath.section== 2){
        if(indexPath.row == 0){
            exproposMemberSelectedViewController *memberSelect = [self.storyboard instantiateViewControllerWithIdentifier:@"memberSelect2"];
            memberSelect.viewController = self;
            memberSelect.contentSizeForViewInPopover =  CGSizeMake(500, 500);
            [self.navigationController pushViewController:memberSelect animated:YES];
        }
        
        if(indexPath.row == 1){
            exproposDealItemSelectedViewController *dealItemSelect = [[exproposDealItemSelectedViewController alloc]init];
            dealItemSelect.viewController = self;
            [self.navigationController pushViewController:dealItemSelect animated:YES];
        }
        
        if(indexPath.row == 2){
            exproposStoreSelectedViewController *storeSelect = [[exproposStoreSelectedViewController alloc]init];
            storeSelect.viewController = self;
            [self.navigationController pushViewController:storeSelect animated:YES];
        }
        
        if(indexPath.row == 3){
            exproposPayTypeViewController *payTypeSelect = [[exproposPayTypeViewController alloc]init];
            payTypeSelect.viewController = self;
            [self.navigationController pushViewController:payTypeSelect animated:YES];
        }
    }
    
    
}

-(void)showOrderNumPopover:(UITableViewCell *)cell {
    //弹出窗口大小，如果屏幕画不下，会挤小的。这个值默认是320x1100
    _popover.popoverContentSize = CGSizeMake(300, 200);
    //popoverRect的中心点是用来画箭头的，如果中心点如果出了屏幕，系统会优化到窗口边缘
    CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
    [_popover presentPopoverFromRect:popoverRect
                                     inView:cell //上面的矩形坐标是以这个view为参考的
                   permittedArrowDirections:UIPopoverArrowDirectionUp //箭头方向
                                   animated:YES];
}

#pragma mark -
@end
