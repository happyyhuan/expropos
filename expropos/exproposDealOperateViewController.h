//
//  exproposDealOperateViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMyTableView.h"
#import "ExproMultipleTableView.h"
@class ExproMultipleTableView;
@class exproposMemberSelectedViewController;
@class ExproMember;
@class exproposMainViewController;
@protocol ExproMutableTableViewDelegate;
@protocol ExproMutableTableViewDataSource;
@class exproposDealOperateMenuViewController;
@class ExproDeal;
@class exproposDealOperate;


@interface exproposDealOperateViewController : UIViewController <ExproMutableTableViewDataSource,ExproMutableTableViewDelegate>
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealItemTableView;
@property (strong, nonatomic) IBOutlet UIView *scanGoodsView;
@property (strong, nonatomic) ExproMember *member;
@property (strong, nonatomic) exproposDealOperateMenuViewController *dealOperateMenu;

@property (strong, nonatomic) exproposMainViewController *mainController;
@property (strong, nonatomic) NSMutableArray *mySelectedGoods;
@property (strong, nonatomic) NSMutableDictionary *goodsAndAmount;
@property (strong, nonatomic) ExproDeal *deal;
@property (strong, nonatomic) exproposDealOperate *operatingDeals;

-(void)addToolBarItem;
-(void)reloadDatas;
@end
