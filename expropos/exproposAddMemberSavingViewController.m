//
//  exproposAddMemberSavingViewController.m
//  expropos
//
//  Created by haitao chen on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposAddMemberSavingViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "exproposAddMemberSavingListViewController.h"
#import "CoreData/CoreData.h"
#import "Restkit/RestKit.h"
#import "exproposAppDelegate.h"
#import "ExproStore.h"


@interface exproposAddMemberSavingViewController ()

@end

@implementation exproposAddMemberSavingViewController
@synthesize member = _member;
@synthesize tableView = _tableView;
@synthesize rightView = _rightView;
@synthesize keys = _keys;
@synthesize memberSaving = _memberSaving;
@synthesize addMemberSavingList = _addMemberSavingList;
@synthesize deal = _deal;
@synthesize operatingDeals = _operatingDeals;
@synthesize popover = _popover;
@synthesize dateSelected = _dateSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5.0f;
    self.view.layer.masksToBounds = YES;
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    self.view.layer.borderWidth = 3.0f;
    
	self.tableView.layer.cornerRadius = 5.0f;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableView.layer.borderWidth = 3.0f;
    
    self.rightView.layer.cornerRadius = 5.0f;
    self.rightView.layer.masksToBounds = YES;
    self.rightView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.rightView.layer.borderWidth = 3.0f;
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    for(JPStupidButton *button in _keys){
        button.buttonClickDelegate = self;
    }
    
   [ self addObserver:self forKeyPath:@"member" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
   
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
    
    CGRect frame1 = self.tableView.frame;
    frame1.origin = CGPointMake(6, 8);
    self.tableView.frame = frame1;
    
    CGRect frame2 = self.rightView.frame;
    frame2.origin = CGPointMake(314, 8);
    self.rightView.frame = frame2;
    
    
    _addMemberSavingList = nil;
    UIView *theView = [self.view viewWithTag:112];
    [theView removeFromSuperview];
}


-(void)touch:(id)sender
{
    NSString * str = _memberSaving.text;
    UIButton *button = (UIButton *)sender;
    if([button.titleLabel.text isEqualToString:@"."]){
        if(str.length == 0){
                return;
        }

    }
    if([button.titleLabel.text isEqualToString:@"确定"]){
               
        if(_deal == nil){
            _deal = [ExproDeal object];
        }
        _deal.state = [NSNumber numberWithInt:1];
        _deal.createTime = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:[NSDate date]];
        
        exproposAppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
        NSFetchRequest *request = [ExproMember fetchRequest];
        request.predicate = [NSPredicate predicateWithFormat:@"user.gid == %@",appdelegate.currentUser.gid];
        ExproMember *m = [[ExproMember objectsWithFetchRequest:request] objectAtIndex:0];
        _deal.dealer = m;
        
        _deal.cash = [NSNumber numberWithDouble:self.memberSaving.text.doubleValue];
        _deal.payment = [NSNumber numberWithDouble:self.memberSaving.text.doubleValue];
        _deal.type = [NSNumber numberWithInt:2];
        _deal.customer = _member;
       
        
        exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSArray *members = [ExproMember findAll];
        for(ExproMember *member in members){
            if(member.user.gid == appDelegate.currentUser.gid){
                _deal.dealer = member;
                _deal.store =  member.store;
            }
        }
        
          
        
        [[RKObjectManager sharedManager].objectStore save:nil];
        
        
        _operatingDeals = [[exproposDealOperate alloc]init];
        _operatingDeals.reserver = self;
        _operatingDeals.succeedCallBack = @selector(createDealSuccess:);
        _operatingDeals.failedCallBack = @selector(createDealfail);
        
        NSLog(@"%@",_deal.type);
        NSLog(@"%@",_deal.state);
        NSLog(@"%@",_deal.store);
        NSLog(@"%@",_deal.payment);
        NSLog(@"%@",_deal.customer);
        NSLog(@"%@",_deal.dealer);
        
        if(!_deal.customer.savingDueTime){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示 " message:@"请选择储值有效期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithKeysAndObjects:@"type",_deal.type,@"state",_deal.state,@"store_id",(_deal.store ? _deal.store.gid:[NSNumber numberWithInt:0]),@"payment",_deal.payment,@"cash",_deal.cash,@"point",_deal.point,@"pay_type",_deal.payType,@"customer_id",_deal.customer.gid,@"saving_due_time",[self dateToStr:_deal.customer.savingDueTime ],@"dealer_id",_deal.dealer.gid, nil];
        [_operatingDeals createAddmemberSavingDeal:dic];
        
                return;
    }
    
    NSString *newStr = [NSString stringWithFormat:@"%@%@",str,button.titleLabel.text];
    _memberSaving.text = newStr;
    
}
-(NSString *)dateToStr:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}

-(void)createDealSuccess:(id)obj
{
    
    NSLog(@"success");
    NSMutableDictionary *dic = (NSMutableDictionary*)obj;
    NSString *gid  = [dic objectForKey:@"gid"];
    
    _deal.gid = [NSNumber numberWithInt:gid.intValue];
    _member.savings = [NSNumber numberWithDouble:(_member.savings.doubleValue+_deal.payment.doubleValue)];
    [[RKObjectManager sharedManager].objectStore save:nil];
    [self.tableView reloadData];
    self.memberSaving.text = @"";
}

-(void)createDealfail
{
    [_deal deleteEntity];
    [[RKObjectManager sharedManager].objectStore save:nil];
    _deal = nil;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setRightView:nil];
    [self setKeys:nil];
    [self setMemberSaving:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma  mark tableview Delegate and dataSource methods:
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"memberCell";
    UITableViewCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    int row = indexPath.row;
    if(row == 0){
        cell.imageView.image = [UIImage imageNamed:@"member.png"];
        cell.detailTextLabel.text = _member.petName;
    }

if(row == 1){
    cell.textLabel.text = @"电话：";
    cell.detailTextLabel.text = _member.user.cellphone;
}
if(row ==2){
    cell.textLabel.text = @"储值：";
    cell.detailTextLabel.text =[NSString stringWithFormat:@"¥%g",  _member.savings.doubleValue];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
    if(row ==3){
        cell.textLabel.text = @"储值有效期：";
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@", _member.savingDueTime?  [self dateToStr:_member.savingDueTime]:@""];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
if(row ==4){
    cell.textLabel.text = @"积分：";
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%i",  _member.point.intValue];
}
return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(!_dateSelected){
            _dateSelected = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
        }
        _dateSelected.viewController = self;
        if(!_popover){
            _popover = [[UIPopoverController alloc] initWithContentViewController:_dateSelected];
        }
       [_popover presentPopoverFromRect:[cell frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        return;
    }
    
    
    if(!_addMemberSavingList){
        _addMemberSavingList =  [[exproposAddMemberSavingListViewController alloc] init];
        _addMemberSavingList.view.frame = CGRectMake(720, 0, 710, 440);
        _addMemberSavingList.dateSelected = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
        [self.view addSubview:_addMemberSavingList.view ];
    }
    _addMemberSavingList.member = self.member;
    self.tableView.tag = 110;
    self.rightView.tag = 111;
    _addMemberSavingList.view.tag = 112;
    
    //开始动画 
    [UIView beginAnimations:nil context:nil];  
    //设定动画持续时间 
    [UIView setAnimationDuration:0.5]; 
    //动画的内容 
    CGRect frame = self.tableView.frame;
    CGRect frame2 = self.rightView.frame;
    CGRect frame3 = _addMemberSavingList.view.frame;
    
    frame.origin.x -= 710+10; 
    frame2.origin.x -= 710+10;
    frame3.origin.x -= 720;
    
    [self.tableView setFrame:frame];
    [self.rightView setFrame:frame2];
    [_addMemberSavingList.view setFrame:frame3];
    
    //动画结束 
    [UIView commitAnimations]; 
}


#pragma mark - 
- (IBAction)deleteOneNum:(UIButton *)sender {
    NSString *str = _memberSaving.text;
    
    if(str.length == 0){
        return;
    }else {
        _memberSaving.text =[ str substringToIndex:str.length-1 ];
    }
}
@end
