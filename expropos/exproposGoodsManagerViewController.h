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
/*
 *此类用于商品管理：商品的添加，删除，修改和商品详细信息的展示
 */
@interface exproposGoodsManagerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
//myRootViewController表示系统的主界面对象，用于返回系统主界面
@property (strong, nonatomic) UISplitViewController *myRootViewController;
@property (strong, nonatomic) IBOutlet UIView *topView;//上侧视图对象
@property (strong, nonatomic) IBOutlet UITableView *leftView;//左侧视图对象，是商品选择列表
@property (strong, nonatomic) IBOutlet UIView *rightView;//右侧视图对象
@property (strong, nonatomic) IBOutlet exproposMyScrollView *scrollView;//在右侧视图之上的滚动视图，用于滚动显示增加，展示，修改 商品信息的界面


@property (nonatomic,strong)NSArray *allDatas;//存放最初的顶级商品类型
@property (nonatomic,strong)NSMutableArray *datas;//商品显示列表的源数据
@property (nonatomic,strong)NSMutableArray *searchData;//查询显示列表的源数据
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;//搜索栏
@property (nonatomic,strong)ExproMerchant *merchant;//商户
@property (strong,nonatomic) UIPopoverController *popover;//弹出框对象
@property (strong,nonatomic) exproposGoosTypeSelectedViewController *goodsType;//商品类型选择控制器对象
@property (nonatomic,strong) ExproGoods *selectedGoods;//被选中的商品

@property (nonatomic,strong) NSString *myGoodsName;//添加商品名称
@property (nonatomic,strong) NSString *myGoodsPrice;//添加商品价格
@property (nonatomic,strong) NSString *myGoodsState;//添加商品状态
@property (nonatomic,strong) ExproGoodsType *myGoodsType;//添加商品类型
@property (nonatomic,strong) NSString *myGoodsCode;//添加商品编码
@property (nonatomic,strong) NSString *myGoodsComment;//添加商品备注
@property (nonatomic,strong) exproposGoodsManager *goodsManager;//商品管理的restkit对象，用于与远程服务器的交换

//更新商品
- (IBAction)update:(UIButton *)sender;
//删除商品
- (IBAction)deleteGoods:(UIButton *)sender;

//添加商品
- (IBAction)add:(UIButton*)sender;


@end
