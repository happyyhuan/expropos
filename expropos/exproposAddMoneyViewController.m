//
//  exproposAddMoneyViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposAddMoneyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ExproUser.h"
#import "ExproDeal.h"
#import "ExproStore.h"
#import "exproposDealOperate.h"
#import "ExproDealItem.h"
#import "exproposAppDelegate.h"

@interface exproposAddMoneyViewController ()

@end

@implementation exproposAddMoneyViewController
@synthesize memberInfo = _memberInfo;
@synthesize memberMoney = _memberMoney;
@synthesize memberAddMoney = _memberAddMoney;
@synthesize memberMoneyNow = _memberMoneyNow;
@synthesize memberAddMoneyList = _memberAddMoneyList;
@synthesize member = _member;
@synthesize popover = _popover;
@synthesize memberSelected = _memberSelected;
@synthesize deals = _deals;
@synthesize addMoney = _addMoney;
@synthesize dealOperate = _dealOperate;


-(void)showMemberMoney
{
    if(_member!=nil && _member.savings){
        _memberMoney.text = [NSString stringWithFormat:@"%g",_member.savings.doubleValue];
        _memberMoneyNow.text = [NSString stringWithFormat:@"%g",_member.savings.doubleValue];
    }else {
        _memberMoney.text = [NSString stringWithFormat:@"%g",0];
        _memberMoneyNow.text = [NSString stringWithFormat:@"%g",0];
    }
}

- (IBAction)addMoneyToMember:(UIButton *)sender {
    if(_member == nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择充值会员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //用于设定deal的lid值
    int dealGid = 0;
    int dealItemGid = 0;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //获取应用程序沙盒的Documents目录  
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
    NSString *plistPath1 = [paths objectAtIndex:0];  
    
    //得到完整的文件名  
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"gids.plist"];  
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];  
    if(dic == nil){
        dic = [[NSMutableDictionary alloc]initWithCapacity:20];
    }
    if(dic.count <=0 ){
        [ dic setObject:[NSNumber numberWithInt:0] forKey:@"dealGid"];
        
    }else {
        dealGid = [[dic valueForKey:@"dealGid"] intValue];
        dealItemGid = [[dic valueForKey:@"dealItemGid"] intValue];
    }
    
    ExproDeal *deal = [ExproDeal object];
    
    deal.state = [NSNumber numberWithInt:1];
    deal.createTime = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:[NSDate date]];
    deal.customer = _member;
    deal.cash = [NSNumber numberWithDouble:_addMoney];
    deal.payment = [NSNumber numberWithDouble:_addMoney];
    deal.type = [NSNumber numberWithInt:2];
    deal.lid = [NSNumber numberWithInt:(dealGid+1)];
    [dic setValue:[NSNumber numberWithInt:(dealGid+1)] forKey:@"dealGid"];
    
    
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appDelegate.currentUser.gid){
            deal.dealer = member;
            deal.store =  member.store;
        }
    }
    
    [dic writeToFile:filename atomically:YES];  
    
    [objectManager.objectStore save:nil];
    
    _dealOperate.reserver = self;
    _dealOperate.succeedCallBack = @selector(createDealSuccess:);
    _dealOperate.failedCallBack = @selector(createDealSuccess2);
    [_dealOperate createDeal:deal];
    
    

}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_memberInfo.layer.borderWidth = 4;
    _memberInfo.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _memberAddMoneyList.layer.borderWidth = 1;
    _memberAddMoneyList.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.view.layer.borderWidth = 4;
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _memberInfo.myTableViewDelegate = self;
    _memberInfo.myTableViewDataSource = self;
    _memberAddMoneyList.multipleDataSource = self;
    _memberAddMoneyList.multipleDelegate = self;
    
    _deals = [[NSMutableArray alloc] initWithCapacity:20];
    [self showMemberMoney];
    
    [_memberAddMoney addTarget:self action:@selector(amoutChanged:) forControlEvents:UIControlEventEditingChanged];
    [_memberAddMoney addTarget:self action:@selector(amoutEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _memberAddMoney.keyboardType = UIKeyboardTypeNumberPad;

    _dealOperate = [[exproposDealOperate alloc] init];

}

-(void)amoutChanged:(id)sender
{
    UITextField *amountField = (UITextField*)sender;
    NSString *amountStr = amountField.text;
    amountStr = [amountStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(amountStr.length > 0){
        double amout = amountStr.doubleValue;
        if(amout<=0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            amountField.text = @"";
            _memberMoneyNow.text = _memberMoney.text;
        }else {
            self.addMoney = amout;
            self.memberMoneyNow.text = [NSString stringWithFormat:@"%g",_member.savings.doubleValue+self.addMoney];
        }
    }else {
        _memberMoneyNow.text = _memberMoney.text;
    }

}

-(void)amoutEnd:(id)sender
{
    self.memberMoneyNow.text = [NSString stringWithFormat:@"%g",_member.savings.doubleValue+self.addMoney];
}


- (void)viewDidUnload
{
    [self setMemberInfo:nil];
    [self setMemberMoney:nil];
    [self setMemberAddMoney:nil];
    [self setMemberMoneyNow:nil];
    [self setMemberAddMoneyList:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark MyTableView dataSource and delegate Methods
-(NSInteger)numberOfSectionsInMyTableView:(exproposMyTableView *)tableView
{
    return 1;
}

-(NSInteger)myTableView:(exproposMyTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)myTableView:(exproposMyTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell = nil;
    
    if(section == 0){
        if(row == 0){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            cell.imageView.image = [UIImage imageNamed:@"member.png"];
            if(self.member == nil){
                cell.textLabel.text = @"匿名用户";
                cell.detailTextLabel.text = @"非会员";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else {
                cell.textLabel.text = self.member.petName;
                cell.detailTextLabel.text = @"普通会员";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            
        }else {
            if(row == 1){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                if(self.member == nil){
                    cell.textLabel.text = @"电话:";
                }else {
                    NSString *str = [NSString stringWithFormat:@"电话:%@",self.member.user.cellphone];
                    cell.textLabel.text = str;
                }
                
            }
            if(row == 2){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                NSString *str = [NSString stringWithFormat:@"储值：¥%g",self.member.savings.doubleValue];
                cell.textLabel.text = str;
            }
            if(row == 3){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                NSString *str = [NSString stringWithFormat:@"积分：%g",self.member.point.doubleValue];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.text = str;
            }
        }
    }
    return cell;
}
  
  -(void)myTableView:(exproposMyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"memberSelect"];
        _memberSelected = [nav.viewControllers objectAtIndex:0];
        _memberSelected.viewController = self;
        _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
        _popover.popoverContentSize = CGSizeMake(300, 400);
        self.memberSelected.popover = _popover;
        [_popover presentPopoverFromRect:popoverRect
                                  inView:cell //上面的矩形坐标是以这个view为参考的
                permittedArrowDirections:UIPopoverArrowDirectionAny //箭头方向
                                animated:YES];
        
    }
}
  
#pragma mark -

#pragma mark mutableDelegate and dataSource Methods
- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView
{
    return 5;
}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment
{
    if(segment == 0){
        return 0.4;
    }else if(segment == 4){
        return 0.2;
    }else if(segment == 1){
        return 0.2;
    }else {
        return 0.1;
    }
}
- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment
{
    switch (segment) {
        case 0:
            return @"项目";
            break;
        case 1:
            return @"金额";
            break;
        case 2:
            return @"时间";
            break;
        case 3:
            return @"方式";
            break;
        case 4:
            return @"网点";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath
{
    
    CGFloat _width = [self multipleTableView:tableView proportionForSegment:segment]*tableView.bounds.size.width;
    ExproDeal *deal = (ExproDeal*)[_deals objectAtIndex:indexPath.row];
    switch (segment) {
        case 0:
        {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, 44)];
            NSArray *types =  [NSArray arrayWithObjects:@"消费撤",@"消费",@"充值",@"充值撤销",@"积分增加",@"积分消费",@"积分撤销",@"退货退款",@"抽奖",@"手工调整", nil];
            name.text = [types objectAtIndex:[deal type].intValue];
            if(segment%2==0){
                name.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                name.backgroundColor = [UIColor lightGrayColor];
            }
            name.font = [UIFont systemFontOfSize:12];
            return name;
        }
            break;
        case 1:
        {
            UILabel *menoy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
            double menoys = 0.0;
            menoys =  deal.payment.doubleValue;
            menoy.text = [NSString stringWithFormat:@"%g",menoys];
            if(segment%2==0){
                menoy.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                menoy.backgroundColor = [UIColor lightGrayColor];
            }
            menoy.font = [UIFont systemFontOfSize:12];
            return menoy;
        }
            break;
        case 2:
        {
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *createDateStr = [dateFormatter stringFromDate:deal.createTime];
            //输出格式为：2010-10-27
            time.text = createDateStr;
            if(segment%2==0){
                time.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                time.backgroundColor = [UIColor lightGrayColor];
            }
            time.font = [UIFont systemFontOfSize:12];
            return time;
        }
            break;
        case 3:
        {
            NSArray *payTypes = [NSArray arrayWithObjects:@"现金",@"银行卡",@"积分",@"现金+积分",@"银行卡+积分", nil];
            UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
            NSString *payType = [payTypes objectAtIndex:deal.payType.intValue];
            payTypeLabel.text = payType;
            if(segment%2==0){
                payTypeLabel.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                payTypeLabel.backgroundColor = [UIColor lightGrayColor];
            }
            payTypeLabel.font = [UIFont systemFontOfSize:12];
            return payTypeLabel;
        }
            break;
        case 4:
        {
            UILabel *store = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
            store.text = deal.store.name;
            if(segment%2==0){
                store.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                store.backgroundColor = [UIColor lightGrayColor];
            }
            store.font = [UIFont systemFontOfSize:12];
            return store;
        }
                    
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deals.count;
}

- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:(NSInteger)section
{
    return [UIColor grayColor];
}
- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorSegment:(NSInteger)segment
{
    if(segment%2==0){
        return [UIColor colorWithWhite:0.75 alpha:1];
    }else {
        return [UIColor lightGrayColor];
    }
}
#pragma mark -

-(void)dealsSearchInLocal
{
    
}

@end
