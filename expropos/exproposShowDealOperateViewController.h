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
#import "exproposSignout.h"

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

//交易主界面
@interface exproposShowDealOperateViewController : UIViewController <ExproMutableTableViewDataSource,ExproMutableTableViewDelegate,ButtonClick>
@property (strong, nonatomic) exproposScanViewController *scan;//扫描控制器
@property (strong,nonatomic) IBOutlet UIView *leftView;//左视图
@property (strong,nonatomic) IBOutlet UIView *rightView;//右视图
@property (strong, nonatomic) IBOutlet UIView *shouldGetMoneyView;//显示应收视图界面
@property (strong, nonatomic) IBOutlet UIView *amountView;//购买商品数量视图
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealTableView;//交易明细视图，即显示购买了那些商品的相关信息
@property (strong, nonatomic) IBOutlet UIView *keyBoardView;//视图右下角的键盘按钮视图
@property (strong, nonatomic) IBOutlet UILabel *allGoodsAmounts;//所有选中商品的数量显示Label
@property (strong, nonatomic) IBOutlet UILabel *allGoodsPayments;//所有选中商品的总金额显示Label
@property (strong, nonatomic) exproposDealOperate *operatingDeals;//交易restkit对象，用于远程服务器通信
@property (strong, nonatomic) IBOutlet UIView *topView;//顶部视图

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;//用于显示是交易状态还是商品退货状态
@property (strong, nonatomic) IBOutlet UIButton *goodsComeBackButton;//商品退货按钮
@property (strong, nonatomic) exproposSignout *signout;//退出restkit对象，用于远程服务器通信

//会员充值按钮响应方法
- (IBAction)addMemberSaving:(UIButton *)sender;
//会员开户按钮响应方法
- (IBAction)memberCreate:(UIButton *)sender;
//退货按钮响应方法
- (IBAction)goodsCommeBack:(UIButton *)sender;
//交易查询按钮响应方法
- (IBAction)dealQueryByDealID:(UIButton *)sender;
//会员选择按钮响应方法
- (IBAction)memberSelected:(UIButton *)sender;
//商品选择按钮响应方法
- (IBAction)goodsSelected:(id)sender;

//主页面退出到登陆界面方法
- (void)goBack:(id)sender;
//右下方键盘按钮集合
@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *buttons;
//显示选择商品的编号
@property (strong, nonatomic) IBOutlet UITextField *goodsCode;
//删除输入有误的商品编号的按钮
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
//删除输入有误的商品的编号
- (IBAction)deleteOneGoodsCode:(id)sender;


//选中的商品存放数组
@property (strong, nonatomic) NSMutableArray *mySelectedGoods;
//存放商品的gid和数量的字典
@property (strong, nonatomic) NSMutableDictionary *goodsAndAmount;
//交易的会员
@property (strong, nonatomic) ExproMember *member;
//交易对象
@property (strong, nonatomic) ExproDeal *deal;
//会员选择控制器对象
@property (strong, nonatomic) exproposMemberSelectedViewController *memberSelected;
//弹出窗口控制器
@property (strong, nonatomic) UIPopoverController *popover;
//判断商品选择窗口是否弹出标记
@property (nonatomic) BOOL isPopover;
//商品选择控制器对象
@property (strong,nonatomic) exproposGoodSelectedViewController *goodsSelected;
//用于商品选择的关系控制器对象
@property (strong, nonatomic)  UINavigationController *nav;
//用于表示交易的类型
@property (nonatomic) NSInteger type;
//退货时与退货商品相关联的交易
@property (nonatomic,strong) ExproDeal *repeal;


-(void)reloadViews;
-(void)finish;
@end
