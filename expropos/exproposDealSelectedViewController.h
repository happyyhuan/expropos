//
//  exproposDealSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproMember.h"
#import "exproposUpdateDeals.h"

@class exproposShowDealsSelectedViewController;

@interface exproposDealSelectedViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic,strong) exproposShowDealsSelectedViewController  *showDeals;
@property (nonatomic,strong) UIPopoverController *popover;//popover控制器
@property (nonatomic,strong) NSDate *beginDate;//开始日期
@property (nonatomic,strong) NSDate *endDate;//截止日期
@property (nonatomic,strong) NSString *fromAmoutOfMoney;//最小的金额
@property (nonatomic,strong) NSString *endAmoutOfMoney;//最大的金额
@property (nonatomic,strong) NSMutableArray *members;//会员选择
@property (nonatomic,strong) NSMutableArray *dealItems;//交易类型选择
@property (nonatomic,strong) NSMutableArray *stores;//消费网点选择
@property (nonatomic,strong) NSMutableArray *payTypes;//消费支付类型选择
@property (nonatomic,strong) exproposUpdateDeals *update;//交易查询对象
@property (nonatomic,strong) UIPopoverController *myPopover;//交易查询条件筛选弹出框的控制器
@property (nonatomic,strong)  NSMutableArray *deals;//符合条件的交易结果集

//本地交易查询
-(void) searchInLoacl;
//交易查询方法
-(void)dealSelect;
@end
