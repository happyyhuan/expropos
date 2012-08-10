//
//  exproposAddMemberSavingListViewController.m
//  expropos
//
//  Created by haitao chen on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposAddMemberSavingListViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ExproMultipleTableView.h"
#import "CoreData/CoreData.h"
#import "Restkit/RestKit.h"
#import "ExproMember.h"
#import "ExproStore.h"
#import "NSDate+Helper.h"



@interface exproposAddMemberSavingListViewController (){
    NSMutableArray *datas ;
}
@end

@implementation exproposAddMemberSavingListViewController
@synthesize topView = _topView;
@synthesize tableView = _tableView;
@synthesize deals = _deals;
@synthesize flag = _flag;
@synthesize dealsNumber = _dealsNumber;
@synthesize beginTime = _beginTime;
@synthesize endTime = _endTime;
@synthesize popover = _popover;
@synthesize dateSelected = _dateSelected;
@synthesize dealQuery = _dealQuery;
@synthesize member = _member;

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
    _deals = [[NSMutableArray alloc] initWithCapacity:20];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-paper.png"]];
   
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 710, 60)];
    [_topView addSubview:backImageView];
    _topView.layer.cornerRadius = 5.0f;
    _topView.layer.masksToBounds = YES;
    _topView.layer.borderColor = [[UIColor grayColor] CGColor];
    _topView.layer.borderWidth = 5.0f;
    [_topView addSubview:backImageView];
    [self.view addSubview:_topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"comeback.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(comeback:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(20,10, 40, 40);
    [_topView addSubview:backButton];
    
    UILabel *beginTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 50)];
    beginTimeLabel.backgroundColor = [UIColor clearColor];
    beginTimeLabel.tag = 201;
    if(!_beginTime){
        beginTimeLabel.text = @"开始时间：     今天";
    }
    UIButton *beginTimeButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    beginTimeButton.frame = CGRectMake(270, 10, 40, 40);
    beginTimeButton.tag = 11;
    [beginTimeButton addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(350, 5, 200, 50)];
     endTimeLabel.backgroundColor = [UIColor clearColor];
    endTimeLabel.tag = 202;
    if(!_endTime){
        endTimeLabel.text = @"结束时间：      今天";
    }
    
     NSTimeInterval secondsPerDay = 24 * 60 * 60 - 60; 
    _beginTime = [[NSDate date] beginningOfDay];
    _beginTime = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:_beginTime];
    
    _endTime = [[NSDate alloc] initWithTimeInterval:secondsPerDay sinceDate:_beginTime];
    
    UIButton *endTimeButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    endTimeButton.frame = CGRectMake(550, 10, 40, 40);
    endTimeButton.tag = 12;
    [endTimeButton addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(600, 10, 100, 40);
    [searchButton setTitle:@"搜索 " forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAddMemberSavingList:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topView addSubview:beginTimeLabel];
    [_topView addSubview:endTimeLabel];
    [_topView addSubview:beginTimeButton];
    [_topView addSubview:endTimeButton];
    [_topView addSubview:searchButton];
    
    
    
    _tableView = [[ExproMultipleTableView alloc] initWithFrame:CGRectMake(0, 60, 710, 378)];
    _tableView.layer.cornerRadius = 5.0f;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.borderWidth = 5.0f;
    _tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.multipleDelegate = self;
    _tableView.multipleDataSource = self;
    
    [self.view addSubview:_tableView];
    
    _flag = true;
    
    [self addObserver:self forKeyPath:@"beginTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
     [self addObserver:self forKeyPath:@"endTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
   
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"beginTime"]){
        UILabel *label = (UILabel *)[self.topView viewWithTag:201];
        label.text = [NSString stringWithFormat:@"开始时间：%@",[self dateToString: _beginTime]];
        [self.deals removeAllObjects];
    }
    if([keyPath isEqualToString:@"endTime"]){
        UILabel *label = (UILabel *)[self.topView viewWithTag:202];
        label.text = [NSString stringWithFormat:@"结束时间：%@",[self dateToString: _endTime]];
        [self.deals  removeAllObjects];
    }
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

-(void)chooseTime:(id)sender
{
    if([sender tag] == 11){
        _dateSelected.isBegin = YES;
    }else {
        _dateSelected.isBegin = NO;
    }
    _dateSelected.viewController = self;
    
    if(!_popover){
        _popover = [[UIPopoverController alloc] initWithContentViewController:_dateSelected];
    }
    
    [_popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)searchAddMemberSavingList:(id)sender
{
    if(!_dealQuery){
        _dealQuery = [[exproposUpdateDeals alloc] init];
    }
    _dealQuery.reserver = self;
    _dealQuery.succeedCallBack = @selector(searchAddMemberSavingListCount:);
    _dealQuery.failedCallBack = @selector(searchAddMemberSavingListCountFail);
    [_dealQuery queryDealAmountByCutomerID:_member.gid type:[NSNumber numberWithInt:2]  beginTime:_beginTime endTime:_endTime];
}
-(void)searchAddMemberSavingListCount:(id)obj
{
    NSLog(@"success");
    NSDictionary *dic = (NSDictionary*)obj;
    self.dealsNumber =  [[dic objectForKey:@"count"] intValue];
    
    if(!self.dealsNumber){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"查无充值记录 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.tableView reloadData];
        return;
    }
    if(self.dealsNumber <= self.deals.count){
        [self.tableView reloadData];
        return;
    }
    
    if(!_dealQuery){
        _dealQuery = [[exproposUpdateDeals alloc] init];
    }
    _dealQuery.reserver = self;
    _dealQuery.succeedCallBack = @selector(searchAddMemberSavingListSuccess:);
    _dealQuery.failedCallBack = @selector(searchAddMemberSavingListFail);
    [_dealQuery queryDealByCustomerID:_member.gid start:self.deals.count limit:100 type:2 bt:_beginTime et:_endTime];
    
}
-(void)searchAddMemberSavingListCountFail
{
    NSLog(@"searchAddMemberSavingListCountFail");
}

-(void)searchAddMemberSavingListSuccess:(id)obj
{
    for(ExproDeal *deal in obj){
        [self.deals addObject:deal];
    }
   
    [self.tableView reloadData];
    _flag = YES;
}

-(void)searchAddMemberSavingListFail
{
     NSLog(@"searchAddMemberSavingListFail");
    _flag = YES;
}

-(void)comeback:(id)sender
{
    UITableView *tableView = (UITableView *)[self.view.superview viewWithTag:110 ];
    UIView *rightView = [self.view.superview viewWithTag:111];
    //开始动画 
    [UIView beginAnimations:nil context:nil];  
    //设定动画持续时间 
    [UIView setAnimationDuration:0.5]; 
    //动画的内容 
    CGRect frame = tableView.frame;
    CGRect frame2 = rightView.frame;
    CGRect frame3 = self.view.frame;
    
    frame.origin.x += 710+10; 
    frame2.origin.x += 710+10;
    frame3.origin.x += 720;
    
    [tableView setFrame:frame];
    [rightView setFrame:frame2];
    [self.view setFrame:frame3];
    
    //动画结束 
    [UIView commitAnimations];
    
    [self.deals removeAllObjects];
    [self.tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - DealItemTableview data source and delegate

- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView
{
    return 5;
}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment
{
    return 0.2;
}
- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment
{
    switch (segment) {
        case 0:
            return @"  项目";
            break;
        case 1:
            return @"  操作员";
            break;
        case 2:
            return @"  门店";
            break;
        case 3:
            return @"  金额";
            break;
        case 4:
            return @"  时间";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath
{
    CGFloat _width = [self multipleTableView:tableView proportionForSegment:segment]*tableView.bounds.size.width;
    CGFloat _height = [self multipleTableView:tableView heightForCellAtIndexPath:indexPath];
    
    if(indexPath.row == (self.deals.count)){
      
        switch (segment) {
            case 0:
            {
                UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
                name.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                return name;
            }
                break;
            case 1:
            {
                
                UILabel *operator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
                 operator.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                return operator;    
            }
                break;
            case 2:
            {
                UILabel *store = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
                    store.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                store.font = [UIFont systemFontOfSize:12];
                if(self.deals.count >=self.dealsNumber){
                    store.text = @"已无更新数据";
                }else {
                    store.text = @"更新中。。。。。。";
                }
                 
                return store;  
            }
                break;
            case 3:
            {
                
                UILabel *saving = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
                saving.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                return saving; 
            }
                break;
            case 4:
            {
                UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
                date.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                return date;
            }
                break;
        }
        
    
       
    }
    
    
    ExproDeal *deal = [self.deals objectAtIndex:indexPath.row];
    switch (segment) {
        case 0:
        {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            name.text = [NSString stringWithFormat:@"  %@", @"充值"];
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
            
            UILabel *operator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            operator.text = [NSString stringWithFormat:@"  %@", [deal.dealer petName]];
            if(segment%2==0){
                operator.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                operator.backgroundColor = [UIColor lightGrayColor];
            }
            operator.font = [UIFont systemFontOfSize:12];
            return operator;    
        }
            break;
        case 2:
        {
            UILabel *store = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            store.text = [NSString stringWithFormat:@"  %@", [deal.store name]];
            if(segment%2==0){
                store.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                store.backgroundColor = [UIColor lightGrayColor];
            }
            store.font = [UIFont systemFontOfSize:12];
            return store;  
        }
            break;
        case 3:
        {
            
            UILabel *saving = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            saving.text = [NSString stringWithFormat:@"  %@", [deal cash]];
            if(segment%2==0){
                saving.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                saving.backgroundColor = [UIColor lightGrayColor];
            }
            saving.font = [UIFont systemFontOfSize:12];
            return saving; 
        }
            break;
        case 4:
        {
            UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            date.text = [NSString stringWithFormat:@"  %@", [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:deal.createTime]];
            if(segment%2==0){
                date.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                date.backgroundColor = [UIColor lightGrayColor];
            }
            date.font = [UIFont systemFontOfSize:12];
            return date;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.deals.count>8) {
        return self.deals.count + 1;
    }else {
        return self.deals.count;
    }
    
}

- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:(NSInteger)section
{
    return [UIColor grayColor];
}

- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



-(CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


 
- (void)multipleTableViewScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    
    if (maximumOffset - currentOffset <= -40) {
        NSLog(@"reload");
        if(_flag){
            _flag = NO;
            [self performSelector:@selector(updateDeals)];
        }
       
        
    }
}

-(void)updateDeals
{
    if(self.dealsNumber > self.deals.count){
        [_dealQuery queryDealByCustomerID:_member.gid start:self.deals.count limit:100 type:2 bt:_beginTime et:_endTime];
    }
   
    
    
}

@end 