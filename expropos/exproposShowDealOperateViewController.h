//
//  exproposShowDealOperateViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPStupidButton.h"
#import "ExproMultipleTableView.h"

@class JPStupidButton;
@class ExproMultipleTableView;
@class exproposMemberSelectedViewController;
@class ExproMember;
@class exproposMainViewController;
@protocol ExproMutableTableViewDelegate;
@protocol ExproMutableTableViewDataSource;
@class exproposDealOperateMenuViewController;
@class ExproDeal;
@class exproposDealOperate;
@protocol ButtonClick;
@class exproposGoodSelectedViewController;
@class exproposScanViewController;

@interface exproposShowDealOperateViewController : UIViewController <ExproMutableTableViewDataSource,ExproMutableTableViewDelegate,ButtonClick>
@property (strong, nonatomic) exproposScanViewController *scan;
@property (strong,nonatomic) IBOutlet UIView *leftView;
@property (strong,nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UIView *shouldGetMoneyView;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealTableView;
@property (strong, nonatomic) IBOutlet UIView *keyBoardView;
@property (strong, nonatomic) IBOutlet UILabel *allGoodsAmounts;
@property (strong, nonatomic) IBOutlet UILabel *allGoodsPayments;
@property (strong, nonatomic) exproposDealOperate *operatingDeals;
@property (strong, nonatomic) UISplitViewController *myRootViewController;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *goodsComeBackButton;



- (IBAction)memberCreate:(UIButton *)sender;
- (IBAction)goodsCommeBack:(UIButton *)sender;
- (IBAction)dealQueryByDealID:(UIButton *)sender;
- (IBAction)memberSelected:(UIButton *)sender;
- (IBAction)goodsSelected:(id)sender;


- (IBAction)goBack:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *buttons;
@property (strong, nonatomic) IBOutlet UITextField *goodsCode;

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteOneGoodsCode:(id)sender;

- (IBAction)stateChanged:(UISegmentedControl *)sender;


@property (strong, nonatomic) NSMutableArray *mySelectedGoods;
@property (strong, nonatomic) NSMutableDictionary *goodsAndAmount;
@property (strong, nonatomic) ExproMember *member;
@property (strong, nonatomic) ExproDeal *deal;
@property (strong, nonatomic) exproposMemberSelectedViewController *memberSelected;
@property (strong, nonatomic) UIPopoverController *popover;
@property (nonatomic) BOOL isPopover;
@property (strong,nonatomic) exproposGoodSelectedViewController *goodsSelected;
@property (strong, nonatomic)  UINavigationController *nav;
@property (nonatomic) NSInteger type;



-(void)reloadViews;
-(void)finish;
@end
