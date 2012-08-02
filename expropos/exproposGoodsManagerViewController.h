//
//  exproposGoodsManagerViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMerchant.h"
#import "exproposGoosTypeSelectedViewController.h"
#import "exproposMyScrollView.h"
#import "exproposGoodsManager.h"

@interface exproposGoodsManagerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISplitViewController *myRootViewController;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *leftView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet exproposMyScrollView *scrollView;


@property (nonatomic,strong)NSArray *allDatas;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)NSMutableArray *searchData;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)ExproMerchant *merchant;
@property (strong,nonatomic) UIPopoverController *popover;
@property (strong,nonatomic) exproposGoosTypeSelectedViewController *goodsType;
@property (nonatomic,strong) ExproGoods *selectedGoods;

@property (nonatomic,strong) NSString *myGoodsName;
@property (nonatomic,strong) NSString *myGoodsPrice;
@property (nonatomic,strong) NSString *myGoodsState;
@property (nonatomic,strong) ExproGoodsType *myGoodsType;
@property (nonatomic,strong) NSString *myGoodsCode;
@property (nonatomic,strong) NSString *myGoodsComment;
@property (nonatomic,strong) exproposGoodsManager *goodsManager;

- (IBAction)update:(UIButton *)sender;

- (IBAction)deleteGoods:(UIButton *)sender;


- (IBAction)add:(UIButton*)sender;


@end
