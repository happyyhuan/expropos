//
//  exproposGoodsComeBackViewController.h
//  expropos
//
//  Created by haitao chen on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"
#import "exproposUpdateDeals.h"
#import "exproposDealOperate.h"
#import "JPStupidButton.h"
#import "exproposShowDealOperateViewController.h"
@class ExproDeal;

@interface exproposGoodsComeBackViewController : UIViewController<ExproMutableTableViewDataSource,ExproMutableTableViewDelegate,ButtonClick>

@property (strong, nonatomic) IBOutlet UITextField *dealID;
@property (strong, nonatomic) IBOutlet UILabel *dealInfo;
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealItemTable;
@property (strong, nonatomic) IBOutlet UIView *keys;
@property (strong, nonatomic) IBOutlet UILabel *dealIDLabel;
@property (strong,nonatomic) exproposUpdateDeals *dealQuery;
@property (strong, nonatomic) exproposDealOperate *dealOperate;
@property (strong,nonatomic) ExproDeal *deal;
@property (strong, nonatomic) exproposShowDealOperateViewController *showDealOperate;

@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *buttons;

@end
