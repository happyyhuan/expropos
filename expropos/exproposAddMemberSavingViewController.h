//
//  exproposAddMemberSavingViewController.h
//  expropos
//
//  Created by haitao chen on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMember.h"
#import "JPStupidButton.h"
#import "ExproDeal.h"
#import "exproposAddMemberSavingListViewController.h"
#import "exproposDealOperate.h"
#import "exproposDateSelectedViewController.h"

@interface exproposAddMemberSavingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ButtonClick>
@property (nonatomic,strong) ExproMember *member;
@property (nonatomic,strong) exproposAddMemberSavingListViewController *addMemberSavingList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *keys;
@property (strong, nonatomic) IBOutlet UITextField *memberSaving;
@property (strong, nonatomic) ExproDeal *deal;
@property (strong, nonatomic) exproposDealOperate *operatingDeals;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) exproposDateSelectedViewController *dateSelected;


- (IBAction)deleteOneNum:(UIButton *)sender;


@end
