//
//  exproposAddMoneyViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMyTableView.h"
#import "ExproMultipleTableView.h"
#import "ExproMember.h"
#import "exproposMemberSelectedViewController.h"
#import "ExproMultipleTableView.h"
#import "exproposDealOperate.h"

@interface exproposAddMoneyViewController : UIViewController  <MyTableViewDelegate,MyTableViewDataSource,ExproMutableTableViewDataSource,ExproMutableTableViewDelegate>
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) exproposMemberSelectedViewController *memberSelected;
@property (strong, nonatomic) IBOutlet exproposMyTableView *memberInfo;
@property (strong, nonatomic) IBOutlet UILabel *memberMoney;
@property (strong, nonatomic) IBOutlet UITextField *memberAddMoney;
@property (strong, nonatomic) IBOutlet UILabel *memberMoneyNow;

@property (strong, nonatomic) IBOutlet ExproMultipleTableView *memberAddMoneyList;

@property (strong, nonatomic) ExproMember *member;
@property (nonatomic) double addMoney;
@property (strong, nonatomic) NSMutableArray *deals;
@property (nonatomic,strong) exproposDealOperate *dealOperate;

-(void)dealsSearchInLocal;
-(void)showMemberMoney;
- (IBAction)addMoneyToMember:(UIButton *)sender;

@end
