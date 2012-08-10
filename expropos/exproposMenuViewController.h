//
//  exproposMenuViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
#import "exproposShowDealsSelectedViewController.h"
#import "exproposMemberRegisterController.h"
#import "exproposShowDealOperateViewController.h"
#import "exproposStoreViewController.h"
#import "memberManagerViewController.h"
#import "exproposGoodsManagerViewController.h"


@interface exproposMenuViewController : UITableViewController 
//主窗台控制器
@property (strong,nonatomic) exproposMainViewController *mainViewController;
//菜单内容数组：@"消费", @"充值", @"积分", @"交易查询", @"会员开户"
@property (strong,nonatomic) NSArray *menus;
//交易查询控制器
@property (strong,nonatomic) exproposShowDealsSelectedViewController *showDeal;

//需要加入到主窗体的view的控制器数组
@property (strong,nonatomic) NSMutableArray *controllers;
//交易处理控制器
@property (strong,nonatomic) exproposShowDealOperateViewController *dealOperate;

@property (strong,nonatomic) exproposStoreViewController *storeControll;


@property (strong,nonatomic) exproposMemberRegisterController *memberRegister;

@property (strong,nonatomic) memberManagerViewController *memberManagerControll;
@property (strong,nonatomic) exproposGoodsManagerViewController *goodsManager;

@end
