//
//  exproposShowDealOperateViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposShowDealOperateViewController.h"
#import "ExproMultipleTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "exproposMemberSelectedViewController.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproGoods.h"
#import "exproposMainViewController.h"
#import "exproposGoodSelectedViewController.h"
#import "ExproMultipleTableView.h"
#import "ExproDeal.h"
#import "ExproDealItem.h"
#import "exproposDealOperate.h"
#import "ExproStore.h"
#import "exproposAppDelegate.h"
#import "JPStupidButton.h"
#import "exproposGoodSelectedViewController.h"
#import "exproposNumKeyboard.h"
#import "exproposPayViewController.h"
#import "exproposScanViewController.h"
#import "exproposMemberShowInfoViewController.h"
#import "exproposMemberRegisterController.h"
#import "exproposDealQueryViewController.h"
#import "exproposAddMemberSavingViewController.h"
#import "exproposGoodsComeBackViewController.h"
#import "exproposSignout.h"

@interface exproposShowDealOperateViewController ()
//显示在顶视图上的工具栏视图
@property (nonatomic,strong) UIImageView  *toolbarView;
//用于显示会员基本信息的界面视图
@property (nonatomic,strong) exproposMemberShowInfoViewController *showMemberInfo;
//会员开户的控制器对象
@property (nonatomic,strong) exproposMemberRegisterController *memberRegister;
//交易查询的控制器对象
@property (nonatomic,strong) exproposDealQueryViewController  *dealQuery;
//会员充值的控制器对象
@property (nonatomic,strong) exproposAddMemberSavingViewController *addMemberSaving;
//商品退货的控制器对象
@property (nonatomic,strong) exproposGoodsComeBackViewController *goodsComeBack;
@end

@implementation exproposShowDealOperateViewController
@synthesize memberSelectedButton = _memberSelectedButton;
@synthesize createMemberButton = _createMemberButton;
@synthesize dealSelectedButton = _dealSelectedButton;
@synthesize goodsSelectedButton = _goodsSelectedButton;
@synthesize memberSavingButton = _memberSavingButton;
@synthesize scan = _scan;
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;
@synthesize shouldGetMoneyView = _shouldGetMoneyView;
@synthesize amountView = _amountView;
@synthesize dealTableView = _dealTableView;
@synthesize keyBoardView = _keyBoardView;
@synthesize allGoodsAmounts = _allGoodsAmounts;
@synthesize allGoodsPayments = _allGoodsPayments;
@synthesize buttons = _buttons;
@synthesize goodsCode = _goodsCode;
@synthesize deleteButton = _deleteButton;
@synthesize mySelectedGoods = _mySelectedGoods;
@synthesize goodsAndAmount = _goodsAndAmount;
@synthesize popover = _popover;
@synthesize memberSelected = _memberSelected;
@synthesize member = _member;
@synthesize deal = _deal;
@synthesize isPopover = _isPopover;
@synthesize goodsSelected = _goodsSelected;
@synthesize nav = _nav;
@synthesize operatingDeals = _operatingDeals;
@synthesize type = _type;
@synthesize topView = _topView;
@synthesize statusLabel = _statusLabel;
@synthesize goodsComeBackButton = _goodsComeBackButton;
@synthesize toolbarView = _toolbarView;
@synthesize showMemberInfo = _showMemberInfo;
@synthesize memberRegister = _memberRegister;
@synthesize dealQuery = _dealQuery;
@synthesize addMemberSaving = _addMemberSaving;
@synthesize goodsComeBack = _goodsComeBack;
@synthesize repeal = _repeal;
@synthesize signout =_signout;
@synthesize goodsComebackSelectedButton = _goodsComebackSelectedButton;



//这个方法是在controller的类在IB中创建,但是通过Xcode实例化controller的时候用的
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    //为view上的各个子视图加边框
    _topView.layer.cornerRadius = 5.0;
    _topView.layer.masksToBounds = YES;
	_topView.layer.borderWidth = 3;
    _topView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _toolbarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 60)];
    _toolbarView.image = [UIImage imageNamed:@"1.4背景.png"];
    [_topView addSubview:_toolbarView];
    
    //显示销售人员的基本信息
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 300, 60)];
   exproposAppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [ExproMember fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"user.gid == %@",appdelegate.currentUser.gid];
    ExproMember *m = [[ExproMember objectsWithFetchRequest:request] objectAtIndex:0];
    myLabel.text = [NSString stringWithFormat:@"%@:%@",m.store.name,m.petName];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = [UIFont systemFontOfSize:24];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.textColor = [UIColor blueColor];
    [_toolbarView addSubview:myLabel];
        
    //交易会员的基本信息扩展按钮
    UIButton *myButton = [[UIButton alloc] init];
    myButton.frame = CGRectMake(800, 10,  40, 40);
    [myButton setBackgroundImage:[UIImage imageNamed:@"1扩展.png"] forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(moreMeberInfo:) forControlEvents:UIControlEventTouchUpInside];
    myButton.hidden = YES;
    myButton.tag = 119;
    [_topView addSubview:myButton];
    
    //退出按钮
    UIButton *goBack = [[UIButton alloc] init];
    goBack.frame = CGRectMake(980, 10,  40, 40);
    [goBack setBackgroundImage:[UIImage imageNamed:@"2退出.png"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:goBack];
     
    //选中交易会员的基本信息
    UILabel *myLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(600, 0, 300, 60)];
    myLabel2.text = @"";
    myLabel2.textColor = [UIColor blueColor];
    myLabel2.font = [UIFont systemFontOfSize:15];
    myLabel2.backgroundColor = [UIColor clearColor];
    myLabel2.hidden = YES;
    myLabel2.tag = 1;
    [_toolbarView addSubview:myLabel2];
    
    _leftView.layer.cornerRadius = 10.0;
    _leftView.layer.masksToBounds = YES;
	_leftView.layer.borderWidth = 3;
    _leftView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _rightView.layer.cornerRadius = 10.0;
    _rightView.layer.masksToBounds = YES;
    _rightView.layer.borderWidth = 3;
    _rightView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _shouldGetMoneyView.layer.cornerRadius = 20.0;
    _shouldGetMoneyView.layer.masksToBounds = YES;
    _shouldGetMoneyView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _shouldGetMoneyView.layer.borderWidth = 3;
    
    _amountView.layer.cornerRadius = 20.0;
    _amountView.layer.masksToBounds = YES;
    _amountView.layer.borderWidth = 3;
    _amountView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _dealTableView.layer.cornerRadius = 5;
    _dealTableView.layer.masksToBounds = YES;
    _dealTableView.layer.borderWidth = 3;
    _dealTableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _goodsCode.layer.cornerRadius = 5;
    _goodsCode.layer.masksToBounds = YES;
    _goodsCode.layer.borderWidth = 3;
    _goodsCode.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    _keyBoardView.layer.cornerRadius = 10;
    _keyBoardView.layer.masksToBounds = YES;
    _keyBoardView.layer.borderWidth = 3;
    _keyBoardView.layer.borderColor = [[UIColor whiteColor] CGColor];

    _statusLabel.layer.cornerRadius = 5;
    _statusLabel.layer.masksToBounds = YES;
    _statusLabel.layer.borderWidth = 3;
    _statusLabel.backgroundColor = [UIColor whiteColor];
    _statusLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    _dealTableView.multipleDelegate = self;
    _dealTableView.multipleDataSource = self;
    
    for(JPStupidButton *button in _buttons){
        button.buttonClickDelegate = self;
    }
    _goodsAndAmount = [[NSMutableDictionary alloc] initWithCapacity:20];
    _mySelectedGoods = [[NSMutableArray alloc] initWithCapacity:20];
    
   //为mySelectedGoods实现kvo编程方式
    [self addObserver:self forKeyPath:@"mySelectedGoods" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
   _nav = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsSelected"];
    _goodsSelected = (exproposGoodSelectedViewController *)[_nav.viewControllers objectAtIndex:0];
    _goodsSelected.viewController = self;
    _isPopover = NO;
    
    _allGoodsAmounts.text = @"0";
    _allGoodsPayments.text = @"¥0";
    
    _type = 1;
    
    [self.goodsComebackSelectedButton addTarget:self action:@selector(showGoodsComebackList:) forControlEvents:UIControlEventTouchUpInside];
    
}
//弹出选中会员的基本详细信息
-(void)moreMeberInfo:(id)sender
{
    if(!_showMemberInfo){
        _showMemberInfo = [[exproposMemberShowInfoViewController alloc]init];
    }
    
    _showMemberInfo.member = _member;
    _showMemberInfo.modalPresentationStyle = UIModalPresentationFormSheet;
    _showMemberInfo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:_showMemberInfo animated:YES];
    _showMemberInfo.view.superview.frame = CGRectMake(100,100, 680, 500);

   
    
    //弹出视图的左上角关闭按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0, 0, 60, 60);
    frame.origin.x = _showMemberInfo.view.frame.origin.x - 22;
    frame.origin.y = _showMemberInfo.view.frame.origin.y -22;
    button.frame = frame;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0,4);
    button.layer.shadowOpacity = 0.3;
    [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
    [_showMemberInfo.view.superview addSubview:button];
    
   
}

//关闭弹出框
-(void)closeModalWindow:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //为右下角的键盘视图添加手指滑动手势识别
    UISwipeGestureRecognizer *recognizer;    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft )];    
    [[self keyBoardView] addGestureRecognizer:recognizer]; 
    _keyBoardView.tag = 1;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //为右下角的键盘视图删除手指滑动手势识别
    for (UISwipeGestureRecognizer *recognizer in [[self keyBoardView] gestureRecognizers]) {  
        [[self keyBoardView] removeGestureRecognizer:recognizer];  
    } 
}

//处理识别手势的响应方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{   
    for(JPStupidButton *button in _buttons){
        [button animateUp];
    } 

    if(_scan == nil){
        _scan = [[exproposScanViewController alloc] init];
        [_rightView insertSubview:_scan.view atIndex:0];
        _scan.showDeal = self;
    }
  
    
   
    //开始动画 
    [UIView beginAnimations:nil context:nil];  
    //设定动画持续时间 
    [UIView setAnimationDuration:0.5]; 
    //动画的内容 
    CGRect frame = _keyBoardView.frame;
    CGRect frame2 = _scan.view.frame;
    frame.origin.x -= 360; 
    frame2.origin.x -= 365;
    [_keyBoardView setFrame:frame]; 
    [_scan.view setFrame:frame2];
    //动画结束 
    [UIView commitAnimations]; 
    [_scan.barReaderViewController.readerView start];
   
    [UIApplication sharedApplication].statusBarHidden = NO;
} 

//kvo响应方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if([keyPath isEqualToString:@"mySelectedGoods"]){
        [self reloadViews];
    }
}

//键盘点击事件响应处理的代理方法
-(void)touch:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSString *title = button.titleLabel.text;
    if([@"确定" isEqualToString:title]){
        NSArray *goods = _goodsSelected.searchData;
        if(goods.count == 1){
            ExproGoods *good = [goods lastObject];
            if(![_goodsSelected.mySelectedGoods containsObject:good]){
                [_goodsSelected.mySelectedGoods insertObject:good atIndex:0];
            }else {
                [_goodsSelected.mySelectedGoods removeObject:good];
            }
            [_popover dismissPopoverAnimated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确定输入正确的商品编号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        return;
    }
    if([@"结算" isEqualToString:title]){
        if(_mySelectedGoods.count == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        exproposPayViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"payView"];
        pay.showOperate = self;
        pay.modalPresentationStyle = UIModalPresentationFormSheet;
        pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
        [self presentModalViewController:pay animated:YES];
        pay.view.superview.frame = CGRectMake(100,250, 850, 430);
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        CGRect frame = CGRectMake(0, 0, 44, 44);
        frame.origin.x = pay.view.frame.origin.x - 16;
        frame.origin.y = pay.view.frame.origin.y -16;
        button.frame = frame;
        button.layer.shadowColor = [[UIColor blackColor] CGColor];
        button.layer.shadowOffset = CGSizeMake(0,4);
        button.layer.shadowOpacity = 0.3;
        [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
        [pay.view.superview addSubview:button];
        return;
    }
    if(!_isPopover){
       
        _goodsSelected.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishGoodsSelected)];
        if(_popover == nil){
            _popover = [[UIPopoverController alloc] initWithContentViewController:_nav];
            NSMutableArray *array = [NSMutableArray arrayWithArray:_buttons];
            [array insertObject:_deleteButton atIndex:0];
            _popover.passthroughViews = array;
        }else {
            _popover.contentViewController = _nav;
            NSMutableArray *array = [NSMutableArray arrayWithArray:_buttons];
            [array insertObject:_deleteButton atIndex:0];
            _popover.passthroughViews = array;

        }
        
        _popover.popoverContentSize = CGSizeMake(600, 750);
        [_popover presentPopoverFromRect:CGRectMake(12, 52, 136, 45) inView:self.rightView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        _isPopover = YES;
    }
   
   
    NSString * str = _goodsCode.text;
    NSString *newStr = [NSString stringWithFormat:@"%@%@",str,title];
    _goodsCode.text = newStr;
    
    [_goodsSelected searchWithNameOrId:newStr];
    _goodsSelected.searchBar.text = @"";
    
    
}

- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"mySelectedGoods"];
    [self setShouldGetMoneyView:nil];
    [self setAmountView:nil];
    [self setDealTableView:nil];
    [self setKeyBoardView:nil];
    [self setButtons:nil];
    [self setGoodsCode:nil];
    [self setDeleteButton:nil];
    [self setAllGoodsAmounts:nil];
    [self setAllGoodsPayments:nil];
    [self setTopView:nil];
    [self setStatusLabel:nil];
    [self setGoodsComeBackButton:nil];
    [self setMemberSelectedButton:nil];
    [self setCreateMemberButton:nil];
    [self setDealSelectedButton:nil];
    [self setGoodsSelectedButton:nil];
    [self setMemberSavingButton:nil];
    [super viewDidUnload];
    _leftView = nil;
    _rightView = nil;
    
     
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//屏幕转动结束后触发
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_scan didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


#pragma mark - DealItemTableview data source and delegate

- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView
{
    return 5;
}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment
{
    if(segment == 0){
        return 0.4;
    }else if(segment == 4){
        return 0.2;
    }else if(segment == 1){
        return 0.2;
    }else {
        return 0.1;
    }
}
- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment
{
    switch (segment) {
        case 0:
            return @"项目";
            break;
        case 1:
            return @"数量";
            break;
        case 2:
            return @"单价";
            break;
        case 3:
            return @"小计";
            break;
        case 4:
            return @"折扣";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath
{
    CGFloat _width = [self multipleTableView:tableView proportionForSegment:segment]*tableView.bounds.size.width;
    CGFloat _height = [self multipleTableView:tableView heightForCellAtIndexPath:indexPath];
    ExproGoods *goods = (ExproGoods*)[_mySelectedGoods objectAtIndex:indexPath.row];
    switch (segment) {
        case 0:
        {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
            name.text = [NSString stringWithFormat:@"  %@", goods.name];
//            if(segment%2==0){
//                name.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
//            }else {
//                name.backgroundColor = [UIColor lightGrayColor];
//            }
            name.font = [UIFont systemFontOfSize:12];
            return name;
        }
            break;
        case 1:
        {
            UITextField *amount = [[UITextField alloc] initWithFrame:CGRectMake(0, 15, _width, _height-15)];
            
            amount.tag = goods.gid.intValue;
            [amount addTarget:self action:@selector(amoutBegin:) forControlEvents:UIControlEventEditingDidBegin];
             amount.tag = indexPath.row;
           
            int amounts = [[_goodsAndAmount objectForKey:goods.gid] intValue];
            
            amount.text = [NSString stringWithFormat:@"%i",amounts];
//            if(segment%2==0){
//                amount.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
//            }else {
//                amount.backgroundColor = [UIColor lightGrayColor];
//            }
            amount.font = [UIFont systemFontOfSize:12];
            return amount;
        }
            break;
        case 2:
        {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            
            price.text = [NSString stringWithFormat:@"%g", goods.price.doubleValue];
//            if(segment%2==0){
//                price.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
//            }else {
//                price.backgroundColor = [UIColor lightGrayColor];
//            }
            price.font = [UIFont systemFontOfSize:12];
            return price;
        }
            break;
        case 3:
        {
            
            UILabel *subtotal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            int amounts = [[_goodsAndAmount objectForKey:goods.gid] intValue];
            double subtotals = goods.price.doubleValue * amounts;
            subtotal.text = [NSString stringWithFormat:@"%g",subtotals];
//            if(segment%2==0){
//                subtotal.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
//            }else {
//                subtotal.backgroundColor = [UIColor lightGrayColor];
//            }
            subtotal.font = [UIFont systemFontOfSize:12];
            return subtotal;
        }
            break;
        case 4:
        {
            UILabel *pointer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            pointer.text = @"";
//            if(segment%2==0){
//                pointer.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
//            }else {
//                pointer.backgroundColor = [UIColor lightGrayColor];
//            }
            pointer.font = [UIFont systemFontOfSize:12];
            return pointer;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mySelectedGoods.count;
}

- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:(NSInteger)section
{
    return [UIColor grayColor];
}
//- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorSegment:(NSInteger)segment
//{
//    if(segment%2==0){
//        return [UIColor colorWithWhite:0.75 alpha:1];
//    }else {
//        return [UIColor lightGrayColor];
//    }
//}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)multipleTableView:(ExproMultipleTableView *)tableView
       commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    ExproGoods *goods = [_mySelectedGoods objectAtIndex:row];
    [_goodsAndAmount removeObjectForKey:goods.gid];
    [_mySelectedGoods removeObject:goods];
    [self reloadViews];
}

-(CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UITableViewCellEditingStyle)multipleTableView:(ExproMultipleTableView *)tableView
                  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (IBAction)addMemberSaving:(UIButton *)sender {
    if(!_member){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示 " message:@"请先选择会员，谢谢！" delegate:self cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if(!_addMemberSaving){
        _addMemberSaving = [self.storyboard instantiateViewControllerWithIdentifier:@"addMemberSaving"];
    }
    if(_addMemberSaving.member.gid.intValue != _member.gid.intValue){
        _addMemberSaving.member = _member;
    }
    _addMemberSaving.modalPresentationStyle = UIModalPresentationFormSheet;
    _addMemberSaving.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:_addMemberSaving animated:YES];
    _addMemberSaving.view.superview.frame = CGRectMake(100, 100, 710,440);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0, 0, 44, 44);
    frame.origin.x = _addMemberSaving.view.frame.origin.x - 16;
    frame.origin.y = _addMemberSaving.view.frame.origin.y -16;
    button.frame = frame;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0,4);
    button.layer.shadowOpacity = 0.3;
    [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
    [_addMemberSaving.view.superview addSubview:button];
}

- (IBAction)memberCreate:(UIButton *)sender {
    if(!_memberRegister){
        _memberRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    }
    _memberRegister.viewController = self;
    _memberRegister.modalPresentationStyle = UIModalPresentationFormSheet;
    _memberRegister.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:_memberRegister animated:YES];
    _memberRegister.view.superview.frame = CGRectMake(100,100, 700, 500);

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0, 0, 60, 60);
    frame.origin.x = _memberRegister.view.frame.origin.x - 22;
    frame.origin.y = _memberRegister.view.frame.origin.y -22;
    button.frame = frame;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0,4);
    button.layer.shadowOpacity = 0.3;
    [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
    [_memberRegister.view.superview addSubview:button];
    
}

- (IBAction)goodsCommeBack:(UIButton *)sender {
    if(_mySelectedGoods.count>0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"友情提醒" message:@"本次交易还未处理完成，不支持此操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if(_type ==1){
        _statusLabel.text = @"   当前状态：商品退货";
        _statusLabel.layer.borderColor = [[UIColor redColor]CGColor];
        _statusLabel.textColor = [UIColor redColor];
        _type =0;
        [self setDisableForButtons:NO];
        [_goodsComeBackButton setTitle:@"商品销售" forState:UIControlStateNormal];
        
        if(!_goodsComeBack){
            _goodsComeBack = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsComeBack"];
        }
        _goodsComeBack.showDealOperate = self;
        _goodsComeBack.deal = nil;
        [_goodsComeBack disEnableKeys:YES];
        _goodsComeBack.modalPresentationStyle = UIModalPresentationFormSheet;
        _goodsComeBack.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
        [self presentModalViewController:_goodsComeBack animated:YES];
        _goodsComeBack.view.superview.frame = CGRectMake(60,100, 880, 450);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        CGRect frame = CGRectMake(0, 0, 60, 60);
        frame.origin.x = _goodsComeBack.view.frame.origin.x - 22;
        frame.origin.y = _goodsComeBack.view.frame.origin.y -22;
        button.frame = frame;
        button.layer.shadowColor = [[UIColor blackColor] CGColor];
        button.layer.shadowOffset = CGSizeMake(0,4);
        button.layer.shadowOpacity = 0.3;
        [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
        [_goodsComeBack.view.superview addSubview:button];
        
    }else {
          self.repeal = nil;
        _statusLabel.text = @"   当前状态：商品销售";
         _statusLabel.layer.borderColor = [[UIColor blueColor]CGColor];
        _statusLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
        _statusLabel.textColor = [UIColor blackColor];
        _type =1;
       [_goodsComeBackButton setTitle:@"商品退货" forState:UIControlStateNormal];
        [self setDisableForButtons:YES];
    }
}

-(void)setDisableForButtons:(BOOL)flag
{
    CGFloat theValue = 1.0;
    if(!flag){
        theValue = 0.6;
    }
     
    self.memberSelectedButton.enabled = flag;
    self.memberSelectedButton.alpha = theValue;
    self.createMemberButton.enabled = flag;
    self.createMemberButton.alpha = theValue;
    self.dealSelectedButton.enabled = flag;
    self.dealSelectedButton.alpha = theValue;
    self.memberSavingButton.enabled = flag;
    self.memberSavingButton.alpha = theValue;
    
    for (JPStupidButton *button  in self.buttons) {
        if([button.titleLabel.text isEqualToString:@"结算"]){
            continue;
        }
        button.enabled=flag;
        button.alpha=theValue;
    }
    
    self.goodsComebackSelectedButton.hidden = flag;
    self.goodsSelectedButton.hidden = !flag;
}

//退货查询响应方法
-(void)showGoodsComebackList:(id)sender
{
    if(!_goodsComeBack){
        _goodsComeBack = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsComeBack"];
    }
    _goodsComeBack.showDealOperate = self;
    _goodsComeBack.deal = self.repeal;
    _goodsComeBack.dealID.text =self.repeal? [NSString stringWithFormat:@"%i", self.repeal.gid.intValue]:@"";
    [_goodsComeBack disEnableKeys:NO];
    _goodsComeBack.modalPresentationStyle = UIModalPresentationFormSheet;
    _goodsComeBack.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:_goodsComeBack animated:YES];
    _goodsComeBack.view.superview.frame = CGRectMake(60,100, 880, 450);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0, 0, 60, 60);
    frame.origin.x = _goodsComeBack.view.frame.origin.x - 22;
    frame.origin.y = _goodsComeBack.view.frame.origin.y -22;
    button.frame = frame;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0,4);
    button.layer.shadowOpacity = 0.3;
    [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
    [_goodsComeBack.view.superview addSubview:button];
}

- (IBAction)dealQueryByDealID:(UIButton *)sender {
    if(!_dealQuery){
        _dealQuery = [self.storyboard instantiateViewControllerWithIdentifier:@"dealQueryByDealID"];
    }
    _dealQuery.modalPresentationStyle = UIModalPresentationFormSheet;
    _dealQuery.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:_dealQuery animated:YES];
    _dealQuery.view.superview.frame = CGRectMake(60,100, 880, 450);




    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0, 0, 60, 60);
    frame.origin.x = _dealQuery.view.frame.origin.x - 22;
    frame.origin.y = _dealQuery.view.frame.origin.y -22;
    button.frame = frame;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(0,4);
    button.layer.shadowOpacity = 0.3;
    [button addTarget:self action:@selector(closeModalWindow:) forControlEvents:UIControlEventTouchDown];
    [_dealQuery.view.superview addSubview:button];
}

- (IBAction)memberSelected:(UIButton *)sender {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"memberSelect"];
    _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    CGRect popoverRect = [sender frame];
    _popover.popoverContentSize = CGSizeMake(680,750);
    _memberSelected = [nav.viewControllers objectAtIndex:0];
    _memberSelected.viewController = self;
    _memberSelected.popover = _popover;
    [_popover presentPopoverFromRect:popoverRect
                              inView:self.rightView //上面的矩形坐标是以这个view为参考的
            permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                            animated:YES];
}

- (IBAction)goodsSelected:(id)sender {
    if(!_isPopover){
        _goodsSelected.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishGoodsSelected)];
        _goodsSelected.searchData = nil;
        [_goodsSelected.tableView reloadData];
        if(_popover == nil){
            _popover = [[UIPopoverController alloc] initWithContentViewController:_nav];
          
        }else {
            _popover.contentViewController = _nav;
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:_buttons];
        [array insertObject:_deleteButton atIndex:0];
        _popover.passthroughViews = array;

        _popover.passthroughViews = _buttons;
        _popover.popoverContentSize = CGSizeMake(600, 750);
        [_popover presentPopoverFromRect:CGRectMake(12, 52, 136, 45) inView:self.rightView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        
        _isPopover = YES;
    }
}



- (void)goBack:(id)sender {
    if (self.mySelectedGoods.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message: @"交易还未完成，确认退出？" delegate: self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }else {
        _signout = [[exproposSignout alloc]init];
        _signout.reserver = self;
        _signout.succeedCallBack = @selector(didSignout);
        _signout.contrller = self;
        [_signout signout];
    }
}

-(void)didSignout
{
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    
}


#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        _signout = [[exproposSignout alloc]init];
        _signout.reserver = self;
        _signout.succeedCallBack = @selector(didSignout);
        _signout.contrller = self;
        [_signout signout];
    }else if(buttonIndex == 1){
        return;
    }
    
    
}

#pragma mark -

-(void)finishGoodsSelected
{
    NSLog(@"finishGoodsSelected....");
    [_popover dismissPopoverAnimated:YES];
}


- (IBAction)deleteOneGoodsCode:(id)sender {
    NSString *str = _goodsCode.text;
    
    if(str.length == 0){
        return;
    }else {
        _goodsCode.text =[ str substringToIndex:str.length-1 ];
        [_goodsSelected searchWithNameOrId:_goodsCode.text];
    }
}



-(void)amoutBegin:(id)sender
{    
    UITextField *f = (UITextField *)sender;
     
     NSInteger index = f.tag;
     
     CGFloat _width = [self multipleTableView:self.dealTableView proportionForSegment:0]*self.dealTableView.bounds.size.width;
     CGFloat _width2 = [self multipleTableView:self.dealTableView proportionForSegment:1]*self.dealTableView.bounds.size.width;
     
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
     UITableViewCell *cell = [self.dealTableView cellForRowAtIndexPath:indexPath];
     CGRect rect = CGRectMake(cell.frame.origin.x+_width, cell.frame.origin.y, _width2, cell.frame.size.height);
     
     exproposNumKeyboard *keyboard = [self.storyboard instantiateViewControllerWithIdentifier:@"numKeyboard"];  
    if(!_popover){
        _popover = [[UIPopoverController alloc] initWithContentViewController:keyboard];
    }else {
         _popover.contentViewController = keyboard;
    }
     _popover.popoverContentSize=CGSizeMake(470, 480);   
    
     [_popover presentPopoverFromRect:rect inView:self.dealTableView  permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES]; 
    
    keyboard.viewController = self;
    keyboard.popover = _popover;
    keyboard.goods = [self.mySelectedGoods objectAtIndex:index];
     keyboard.modalInPopover = YES;
    _popover.passthroughViews = nil;
    
     [f resignFirstResponder];
    self.view.alpha = 0.5; 
    
    
    
}


-(void)reloadViews
{
    [self.dealTableView reloadData];
    double sumMoney=0.0;
    int allAmount =0;
    for(ExproGoods *goods in _mySelectedGoods){
        int amount = [[_goodsAndAmount objectForKey:goods.gid] intValue];
        allAmount +=amount;
        sumMoney += goods.price.doubleValue *amount;
    }
    if(_type == 0){
        sumMoney = -sumMoney;
    }
    _allGoodsPayments.text = [NSString stringWithFormat:@"%g",sumMoney];
    _allGoodsAmounts.text = [NSString stringWithFormat:@"%i",allAmount];
    
    
    if(_member!= nil){
       
        
        UILabel *myLabel = (UILabel *)[_toolbarView viewWithTag:1];
        myLabel.hidden = NO;
        myLabel.text = [NSString stringWithFormat:@"会员：%@:%@",_member.user.cellphone, _member.petName];
        
        UIButton *button = (UIButton*) [_topView viewWithTag:119];
        button.hidden = NO;
    }else {
        UILabel *myLabel = (UILabel *)[_toolbarView viewWithTag:1];
        myLabel.hidden = YES;
        UIButton *button = (UIButton*) [_topView viewWithTag:119];
        button.hidden = YES;
    }
}

-(void)finish
{
    NSLog(@"finish.......");
        
    if(_deal == nil){
        _deal = [ExproDeal object];
    }
    _deal.state = [NSNumber numberWithInt:1];
    _deal.createTime = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:[NSDate date]];
    double sum = 0.0;
    for(ExproGoods *g in _mySelectedGoods){
        int amout = [[_goodsAndAmount objectForKey:g.gid] intValue];
        sum += g.price.doubleValue * amout;
    }
    _deal.cash = [NSNumber numberWithDouble:sum];
    _deal.payment = [NSNumber numberWithDouble:sum];
    _deal.type = [NSNumber numberWithInt:_type];
    
   
    _deal.customer = _member;
    _deal.customerID = _member.gid;
    
    int i=0;
    for(ExproGoods *g in _mySelectedGoods){
        
        int amout = [[_goodsAndAmount objectForKey:g.gid] intValue];
        ExproDealItem *dealItem = [ExproDealItem object];
        dealItem.deal = _deal;
        dealItem.goods = g;
        dealItem.num = [NSNumber numberWithInt:amout];
        dealItem.closingCost = g.price;
        dealItem.totalCost = [NSNumber numberWithDouble:(g.price.doubleValue * amout)];
        i++;
    }
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid.intValue == appDelegate.currentUser.gid.intValue){
            _deal.dealer = member;
            _deal.store =  member.store;
        }
    }
    
    
    
    _operatingDeals = [[exproposDealOperate alloc]init];
    _operatingDeals.reserver = self;
    _operatingDeals.succeedCallBack = @selector(createDealSuccess:);
    _operatingDeals.failedCallBack = @selector(createDealfail);
    
    if(_type == 0){
        _deal.repeal = self.repeal;
        if(!_deal.repeal){
            UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:@"提示" message:@"缺少退货交易的原订单号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [_operatingDeals createGoodsComeBackDeal:_deal];
    }else {
         [_operatingDeals createDeal:_deal];
    }
    
}

-(void)createDealSuccess:(id)object
{
    NSLog(@"%@",object);
    NSMutableDictionary *dic = (NSMutableDictionary*)object;
    NSString *gid  = [dic objectForKey:@"gid"];
    
    _deal.gid = [NSNumber numberWithInt:gid.intValue];
    [[RKObjectManager sharedManager].objectStore save:nil];
    
    if(_type == 0){
        self.repeal = nil;
        _statusLabel.text = @"   当前状态：商品销售";
         _statusLabel.layer.borderColor = [[UIColor blueColor]CGColor];
        _statusLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
        _statusLabel.textColor = [UIColor blackColor];
        _type =1;
        [_goodsComeBackButton setTitle:@"商品退货" forState:UIControlStateNormal];
        [self setDisableForButtons:YES];
    }
    
    [self cancels];
}

-(void)createDealfail
{
    NSLog(@"fail");
}



-(void)cancels
{
    NSLog(@"cancel........");
    [_mySelectedGoods removeAllObjects];
    [_goodsAndAmount removeAllObjects];
    _member = nil;
    _deal = nil;
    [self reloadViews];
}

@end
