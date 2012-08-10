//
//  exproposAddMemberSavingListViewController.h
//  expropos
//
//  Created by haitao chen on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"
#import "ExproDeal.h"
#import "exproposDateSelectedViewController.h"
#import "exproposUpdateDeals.h"
#import "ExproMember.h"

@interface exproposAddMemberSavingListViewController : UIViewController <ExproMutableTableViewDelegate,ExproMutableTableViewDataSource>
@property (strong,nonatomic) UIPopoverController *popover;
@property (nonatomic,strong) exproposDateSelectedViewController *dateSelected;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) ExproMultipleTableView *tableView;
@property (nonatomic,strong) NSMutableArray *deals;
@property (nonatomic,strong) ExproMember *member;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) NSInteger dealsNumber;
@property (nonatomic,strong) NSDate *beginTime;
@property (nonatomic,strong) NSDate *endTime;
@property (nonatomic,strong) exproposUpdateDeals *dealQuery;

@end
