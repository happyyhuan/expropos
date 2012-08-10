//
//  exproposGoodsComeBackViewController.m
//  expropos
//
//  Created by haitao chen on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposGoodsComeBackViewController.h"
#import "ExproMultipleTableView.h"
#import "ExproDeal.h"
#import "ExproDealItem.h"
#import <QuartzCore/QuartzCore.h>
#import "exproposUpdateDeals.h"
#import "JPStupidButton.h"
#import "ExproStore.h"
#import "ExproMember.h"
#import "ExproGoods.h"

@interface exproposGoodsComeBackViewController ()
@property (nonatomic,strong) NSMutableArray * array;
@end

@implementation exproposGoodsComeBackViewController
@synthesize dealID = _dealID;
@synthesize dealInfo = _dealInfo;
@synthesize dealItemTable = _dealItemTable;
@synthesize keys = _keys;
@synthesize dealIDLabel = _dealIDLabel;
@synthesize dealQuery = _dealQuery;
@synthesize deal = _deal;
@synthesize buttons = _buttons;
@synthesize dealOperate = _dealOperate;
@synthesize array = _array;
@synthesize showDealOperate = _showDealOperate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dealIDLabel.layer.cornerRadius = 5.0;
    _dealIDLabel.layer.masksToBounds = YES;
    _dealIDLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    _dealIDLabel.layer.borderWidth = 2.0;
    
    _dealInfo.layer.cornerRadius = 5.0;
    _dealInfo.layer.masksToBounds = YES;
    _dealInfo.layer.borderColor = [[UIColor whiteColor] CGColor];
    _dealInfo.layer.borderWidth = 2.0;
    
    _dealItemTable.layer.cornerRadius = 5.0;
    _dealItemTable.layer.masksToBounds = YES;
    _dealItemTable.layer.borderWidth = 2.0;
    _dealItemTable.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _keys.layer.cornerRadius = 5.0;
    _keys.layer.masksToBounds = YES;
    _keys.layer.borderColor = [[UIColor whiteColor] CGColor];
    _keys.layer.borderWidth = 2.0;
    
    self.view.layer.cornerRadius = 10.0;
    self.view.layer.masksToBounds = YES;
    self.view.layer.borderWidth = 3.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.showDealOperate.repeal = self.deal;
    [self reset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_dealQuery = [[exproposUpdateDeals alloc] init];
    _dealQuery.reserver = self;
    _dealQuery.succeedCallBack = @selector(dealQuerySuccess:);
    _dealQuery.failedCallBack = @selector(dealQueryFail);
    _dealID.enabled = NO;
    
    _dealItemTable.multipleDelegate = self;
    _dealItemTable.multipleDataSource = self;
    
    
   
    
    for(JPStupidButton *button in _buttons){
        button.buttonClickDelegate = self;
    }
    [self addObserver:self forKeyPath:@"deal" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"deal"]){
        NSMutableString *str = [[NSMutableString alloc]initWithCapacity:20];
        if([[_deal store] name]){
            [str appendFormat:@"店铺：%@ ",[[_deal store] name]];
        }
        if([[_deal dealer] petName]){
            [str appendFormat:@"职员：%@ ",[[_deal dealer] petName]];
        }
        if([[_deal customer] petName]){
            [str appendFormat:@"顾客：%@ ",[[_deal customer] petName]];
        }
        if([_deal createTime] ){
            
            [str appendFormat:@"时间：%@",[self dateToStr:[_deal createTime]]];
        }
        _dealInfo.text = str;
        [_dealItemTable reloadData];
    }
    
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

-(void)dealQuerySuccess:(id)object
{
    NSLog(@"success");
    self.deal = (ExproDeal*)object;
   
    NSSet *dealItems = _deal.items;
    _array = [[NSMutableArray alloc]initWithCapacity:20];
    for(ExproDealItem *item in dealItems){
        [_array addObject:item];
    }
    [self.dealItemTable reloadData];
}

-(void)dealQueryFail
{
    NSLog(@"fail");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"友情提醒" message:@"本店未能查询到相关交易信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [self reset];
}

-(void)reset
{
    _dealID.text = @"";
    self.deal = nil;
    _dealInfo.text = @"交易基本信息！";
    _deal = nil;
    _array = nil;
}

- (void)viewDidUnload
{
    [self setDealID:nil];
    [self setDealInfo:nil];
    [self setDealItemTable:nil];
    [self setKeys:nil];
    [self setDealIDLabel:nil];
    [self setButtons:nil];
    [self setDeal:nil];
    [self setArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)touch:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *title = button.titleLabel.text;
    
    if([title isEqualToString:@"确定"]){
        if(_dealID.text.length == 0){
            return;
        }
        [_dealQuery dealQueryByDealID:_dealID.text];
    }else if([title isEqualToString:@"C"]){
        if(_dealID.text.length == 0){
            return;
        }
        _dealID.text = [_dealID.text substringToIndex:_dealID.text.length-1];
    }else {
        _dealID.text = [NSString stringWithFormat:@"%@%@",_dealID.text,title];
    }
    
}


#pragma mark - DealItemTableview data source and delegate

- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView
{
    return 3;
}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment
{
    if(segment == 0){
        return 0.4;
    }else {
        return 0.3;
    }
}
- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment
{
    switch (segment) {
        case 0:
            return @"商品名称";
            break;
        case 1:
            return @"数量";
            break;
        case 2:
            return @"单价";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView==%@",tableView);
    CGFloat _width = [self multipleTableView:tableView proportionForSegment:segment]*tableView.bounds.size.width;
    CGFloat _height = [self multipleTableView:tableView heightForCellAtIndexPath:indexPath];
  
    ExproDealItem *dealItem = [_array objectAtIndex:indexPath.row];
    switch (segment) {
        case 0:
        {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            name.text = [NSString stringWithFormat:@"  %@", dealItem.goods.name];
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
            UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            amount.text = [NSString stringWithFormat:@"%i", dealItem.num.intValue];
            if(segment%2==0){
                amount.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                amount.backgroundColor = [UIColor lightGrayColor];
            }
            amount.font = [UIFont systemFontOfSize:12];
            return amount;
        }
            break;
        case 2:
        {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            
            price.text = [NSString stringWithFormat:@"%g", dealItem.goods.price.doubleValue];
            if(segment%2==0){
                price.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                price.backgroundColor = [UIColor lightGrayColor];
            }
            price.font = [UIFont systemFontOfSize:12];
            return price;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
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
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



-(CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UITableViewCellEditingStyle)multipleTableView:(ExproMultipleTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString*)multipleTableView:(ExproMultipleTableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"退货";
}

-(void)multipleTableView:(ExproMultipleTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExproGoods *good = [[_array objectAtIndex:indexPath.row] goods];
    NSMutableArray *data = [NSMutableArray arrayWithArray:_showDealOperate.mySelectedGoods];
    [data addObject:good];
    [_showDealOperate.goodsAndAmount setObject:[NSNumber numberWithInt:1] forKey:[good gid]];
    _showDealOperate.mySelectedGoods = data;
    
      [_array removeObject:[_array objectAtIndex:indexPath.row]];
    [self.dealItemTable reloadData];
}




@end
