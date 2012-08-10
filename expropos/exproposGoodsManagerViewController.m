//
//  exproposGoodsManagerViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposGoodsManagerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RestKit/RestKit.h"
#import "CoreData/CoreData.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"
#import "ExproMerchant.h"
#import "exproposAppDelegate.h"
#import "ExproMember.h"
#import "exproposGoosTypeSelectedViewController.h"
#import "exproposGoodsManager.h"



@interface exproposGoodsManagerViewController ()
@property (nonatomic,strong) UIImageView  *toolbarView;
@property (nonatomic,strong) UIView *addView;
@property (nonatomic,strong) UIView *updateView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong)  UIButton *typeButton;

@end

@implementation exproposGoodsManagerViewController
@synthesize myRootViewController = _myRootViewController;
@synthesize topView = _topView;
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;
@synthesize scrollView = _scrollView;
@synthesize toolbarView = _toolbarView;
@synthesize searchBar = _searchBar;
@synthesize searchData = _searchData;
@synthesize allDatas = _allDatas;
@synthesize datas = _datas;
@synthesize merchant = _merchant;
@synthesize showView = _showView;
@synthesize updateView = _updateView;
@synthesize addView = _addView;
@synthesize selectedGoods = _selectedGoods;
@synthesize popover = _popover;
@synthesize goodsType = _goodsType;
@synthesize typeButton = _typeButton;
@synthesize myGoodsName = _myGoodsName;
@synthesize myGoodsType  = _myGoodsType;
@synthesize myGoodsPrice = _myGoodsPrice;
@synthesize myGoodsState = _myGoodsState;
@synthesize goodsManager = _goodsManager;
@synthesize myGoodsCode = _myGoodsCode;
@synthesize myGoodsComment = _myGoodsComment;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor] ];
    
	_topView.layer.cornerRadius = 5.0;
    _topView.layer.masksToBounds = YES;
	_topView.layer.borderWidth = 3;
    _topView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _toolbarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 60)];
    _toolbarView.image = [UIImage imageNamed:@"3.jpg"];
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    logoImage.image = [UIImage imageNamed:@"123.jpg"];
    [_toolbarView addSubview:logoImage];
    [_topView addSubview:_toolbarView];
    
    UIButton *goBack = [[UIButton alloc] init];
    goBack.frame = CGRectMake(980, 10,  40, 40);
    [goBack setBackgroundImage:[UIImage imageNamed:@"close@2x.png"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:goBack];
    
    _leftView.layer.cornerRadius = 5.0;
    _leftView.layer.masksToBounds = YES;
	_leftView.layer.borderWidth = 3;
    _leftView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _leftView.delegate = self;
    _leftView.dataSource = self;
    self.searchBar.delegate = self;
    [self loaddata];
    
    _rightView.layer.cornerRadius = 5.0;
    _rightView.layer.masksToBounds = YES;
	_rightView.layer.borderWidth = 3;
    _rightView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _scrollView.layer.cornerRadius = 5.0;
    _scrollView.layer.masksToBounds = YES;
	_scrollView.layer.borderWidth = 3;
    _scrollView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _scrollView.contentSize = CGSizeMake(616*3, 480);
    _scrollView.contentOffset = CGPointMake(616, 0);
    _scrollView.delegate = self;
    
    _addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 616, 480)];
    [_addView setBackgroundColor:[UIColor whiteColor]];
    _showView = [[UIView alloc]initWithFrame:CGRectMake(616, 0, 616, 480)];
     [_showView setBackgroundColor:[UIColor whiteColor]];
    _updateView = [[UIView alloc]initWithFrame:CGRectMake(616*2, 0, 616, 480)];
    [_updateView setBackgroundColor:[UIColor whiteColor]];
    
    
    [_scrollView addSubview:_addView];
    [_scrollView addSubview:_showView];
    [_scrollView addSubview:_updateView];
    _scrollView.pagingEnabled = YES;
    
    _goodsType = [[exproposGoosTypeSelectedViewController alloc] init];
     
    _myGoodsState = @"1";
    [self addObserver:self forKeyPath:@"myGoodsType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"myGoodsName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"myGoodsPrice" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"myGoodsCode" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"myGoodsComment" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _showView.layer.cornerRadius = 5.0;
    _showView.layer.masksToBounds = YES;
	_showView.layer.borderWidth = 3;
    _showView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _addView.layer.cornerRadius = 5.0;
    _addView.layer.masksToBounds = YES;
	_addView.layer.borderWidth = 3;
    _addView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _updateView.layer.cornerRadius = 5.0;
    _updateView.layer.masksToBounds = YES;
	_updateView.layer.borderWidth = 3;
    _updateView.layer.borderColor = [[UIColor grayColor] CGColor];

    [self addObserver:self forKeyPath:@"selectedGoods" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
     [self addObserver:self forKeyPath:@"selectedGoods.type" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
   //showView: 
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 580, 60)];
    title.text = [NSString stringWithFormat:@"商品基本信息展示"];
    title.textAlignment = UITextAlignmentCenter;
    title.textColor = [UIColor blueColor];
    [_showView addSubview:title];
    
    UILabel *gid = [[UILabel alloc]initWithFrame:CGRectMake(20, 20+60, 580, 30)];
    gid.tag = 101;
    gid.text = [NSString stringWithFormat:@"编号：                        %i",(_selectedGoods!=nil) ? ( _selectedGoods.gid.intValue):0];
    [_showView addSubview:gid];
    
    UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(20,60+60,  580, 30)];
    code.tag = 102;
    code.text = [NSString stringWithFormat:@"条形码：                      %@",(_selectedGoods!=nil) ?  [_selectedGoods code] : @""];
    [_showView addSubview:code];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20,100+60,  180, 60)];
   UILabel *nameInfo = [[UILabel alloc]initWithFrame:CGRectMake(180,100+60,  380, 60)];
    nameInfo.tag = 103;
    name.text = [NSString stringWithFormat:@"名称：                        "];
    nameInfo.text =(_selectedGoods!=nil) ? _selectedGoods.name:@"";
    nameInfo.numberOfLines = 3;
    [_showView addSubview:name];
    [_showView addSubview:nameInfo];
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(20,140+60+30,  580, 30)];
    price.tag = 104;
    price.text = [NSString stringWithFormat:@"单价：                        %g",(_selectedGoods!=nil) ?_selectedGoods.price.doubleValue:0.0];
    [_showView addSubview:price];
    
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(20,180+60+30,  580, 30)];
    type.tag = 105;
    type.text = [NSString stringWithFormat:@"类型：                        %@",(_selectedGoods!=nil) ?_selectedGoods.type.name:@""];
    [_showView addSubview:type];
    
    UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(20,220+60+30,  580, 30)];
    comment.tag = 106;
    comment.text = [NSString stringWithFormat:@"描述：                        %@",(_selectedGoods!=nil) ?_selectedGoods.comment:@""];
    [_showView addSubview:comment];
    
    
   //updateView:
    UILabel *updateviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 580, 60)];
    updateviewTitle.text = [NSString stringWithFormat:@"更新商品"];
    updateviewTitle.textAlignment = UITextAlignmentCenter;
    updateviewTitle.textColor = [UIColor blueColor];
    [_updateView addSubview:updateviewTitle];
    
    UILabel *updateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 100, 30)];
    updateName.text = @"商品名称：";
    UITextField *updateNameValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 80, 460, 30)];
    updateNameValue.borderStyle = UITextBorderStyleLine;
    [updateNameValue addTarget:self action:@selector(updateMyGoodsname:) forControlEvents:UIControlEventEditingChanged];
    [_updateView addSubview:updateName];
    [_updateView addSubview:updateNameValue];
    updateNameValue.tag = 111;
    
    
   
    UILabel *updatePrice = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 30)];
    updatePrice.text = @"商品单价：";
    UITextField *updatePriceValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 120, 460, 30)];
    updatePriceValue.borderStyle = UITextBorderStyleLine;
    updatePriceValue.keyboardType = UIKeyboardTypeNumberPad;
    [updatePriceValue addTarget:self action:@selector(updateMyGoodsPrice:) forControlEvents:UIControlEventEditingChanged];
    [_updateView addSubview:updatePrice];
    [_updateView addSubview:updatePriceValue];
    updatePriceValue.tag = 112;
    
    UILabel *updateCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 100, 30)];
    updateCode.text = @"商品编码：";
    UITextField *updateCodeValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 160, 460, 30)];
    updateCodeValue.borderStyle = UITextBorderStyleLine;
    updateCodeValue.keyboardType = UIKeyboardTypeNumberPad;
    [updateCodeValue addTarget:self action:@selector(updateMyGoodsCode:) forControlEvents:UIControlEventEditingChanged];
    [_updateView addSubview:updateCode];
    [_updateView addSubview:updateCodeValue];
    updateCodeValue.tag = 113;
    
    UILabel *updateComment = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 100, 30)];
   updateComment.text = @"商品备注：";
    UITextField *updateCommentValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 200, 460, 30)];
    updateCommentValue.borderStyle = UITextBorderStyleLine;
    [updateCommentValue addTarget:self action:@selector(updateMyGoodsComment:) forControlEvents:UIControlEventEditingChanged];
    
    [updateCommentValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [updateCommentValue addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [updateCommentValue addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    [_updateView addSubview:updateComment];
    [_updateView addSubview:updateCommentValue];
    updateCommentValue.tag = 114;
    
    UILabel *updateState = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 100, 30)];
    updateState.text = @"商品状态：";
    NSArray *updatestates = [[NSArray alloc] initWithObjects:@"下架",@"上架", nil];
    UISegmentedControl *updatesegment = [[UISegmentedControl alloc] initWithItems:updatestates];
    updatesegment.frame = CGRectMake(320, 240, 260, 30);
     updatesegment.selectedSegmentIndex = 1;
    [ updatesegment addTarget:self action:@selector(updateMyGoodsState:) forControlEvents:UIControlEventValueChanged];
    [_updateView addSubview:updateState];
    [_updateView addSubview:updatesegment];
    updatesegment.tag = 115;
    
    
    UILabel *updateType = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, 300, 30)];
    updateType.text = @"商品类型：";
    updateType.tag = 116;
    UIButton *updateTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateTypeButton.frame = CGRectMake(350,280, 200, 60);
    updateTypeButton.titleLabel.text = @"请选择商品类型";
    [updateTypeButton setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
    [updateTypeButton addTarget:self action:@selector(updateGoodsTypes:) forControlEvents:UIControlEventTouchUpInside];
    [_updateView addSubview:updateType];
    [_updateView  addSubview:updateTypeButton];
    
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame = CGRectMake(130,360, 260, 60);
    [updateButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateGoods:) forControlEvents:UIControlEventTouchUpInside];
    [_updateView addSubview:updateButton];
    
    
  
    //addView:
    UILabel *addviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 580, 60)];
    addviewTitle.text = [NSString stringWithFormat:@"增加商品"];
    addviewTitle.textAlignment = UITextAlignmentCenter;
    addviewTitle.textColor = [UIColor blueColor];
    [_addView addSubview:addviewTitle];
    
    UILabel *newName = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 100, 30)];
    newName.text = @"商品名称：";
    UITextField *nameValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 80, 460, 30)];
    nameValue.borderStyle = UITextBorderStyleLine;
    [nameValue addTarget:self action:@selector(createMyGoodsname:) forControlEvents:UIControlEventEditingChanged];
    [_addView addSubview:newName];
    [_addView addSubview:nameValue];
    nameValue.tag = 111;
    
    
    
    UILabel *newPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 30)];
    newPrice.text = @"商品单价：";
    UITextField *priceValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 120, 460, 30)];
    priceValue.borderStyle = UITextBorderStyleLine;
    priceValue.keyboardType = UIKeyboardTypeNumberPad;
    [priceValue addTarget:self action:@selector(createMyGoodsPrice:) forControlEvents:UIControlEventEditingChanged];
    [_addView addSubview:newPrice];
    [_addView addSubview:priceValue];
    priceValue.tag = 112;
    
    UILabel *newCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 100, 30)];
    newCode.text = @"商品编码：";
    UITextField *newCodeValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 160, 460, 30)];
    newCodeValue.borderStyle = UITextBorderStyleLine;
    newCodeValue.keyboardType = UIKeyboardTypeNumberPad;
    [newCodeValue addTarget:self action:@selector(createMyGoodsCode:) forControlEvents:UIControlEventEditingChanged];
    [_addView addSubview:newCode];
    [_addView addSubview:newCodeValue];
    newCodeValue.tag = 113;
    
    UILabel *newComment = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 100, 30)];
    newComment.text = @"商品备注：";
    UITextField *commentValue = [[UITextField alloc] initWithFrame:CGRectMake(120, 200, 460, 30)];
    commentValue.borderStyle = UITextBorderStyleLine;
    [commentValue addTarget:self action:@selector(createMyGoodsComment:) forControlEvents:UIControlEventEditingChanged];
    
    [commentValue addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [commentValue addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [commentValue addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    [_addView addSubview:newComment];
    [_addView addSubview:commentValue];
    commentValue.tag = 114;
    
    UILabel *newState = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 100, 30)];
    newState.text = @"商品状态：";
    NSArray *states = [[NSArray alloc] initWithObjects:@"下架",@"上架", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:states];
    segment.frame = CGRectMake(320, 240, 260, 30);
    segment.selectedSegmentIndex = 1;
    [segment addTarget:self action:@selector(createMyGoodsState:) forControlEvents:UIControlEventValueChanged];
    [_addView addSubview:newState];
    [_addView addSubview:segment];
    segment.tag = 115;
    
    
    UILabel *newType = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, 300, 30)];
    newType.text = @"商品类型：";
    newType.tag = 116;
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(350,280, 200, 60);
    _typeButton.titleLabel.text = @"请选择商品类型";
    [_typeButton setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(selectedGoodsTypes:) forControlEvents:UIControlEventTouchUpInside];
    [_addView addSubview:newType];
    [_addView  addSubview:_typeButton];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(130,360, 260, 60);
    [addButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addGoods:) forControlEvents:UIControlEventTouchUpInside];
    [_addView addSubview:addButton];
    
   
  
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"myGoodsType"]){
        UILabel *label =(UILabel*)[_addView viewWithTag:116];
        label.text = [NSString stringWithFormat:@"商品类型：     %@",_myGoodsType ?  _myGoodsType.name:@""];
    }
    
    if([keyPath isEqualToString:@"myGoodsName"]){
        UITextField *textField =(UITextField*)[_addView viewWithTag:111];
        textField.text = self.myGoodsName;
    }
    
    if([keyPath isEqualToString:@"myGoodsPrice"]){
        UITextField *textField =(UITextField*)[_addView viewWithTag:112];
        textField.text = self.myGoodsPrice;
    }
    
    if([keyPath isEqualToString:@"myGoodsCode"]){
        UITextField *textField =(UITextField*)[_addView viewWithTag:113];
        textField.text = self.myGoodsCode;
    }
    if([keyPath isEqualToString:@"myGoodsComment"]){
        UITextField *textField =(UITextField*)[_addView viewWithTag:114];
        textField.text = self.myGoodsComment;
    }
    
    if([keyPath isEqualToString:@"myGoodsState"]){
        UISegmentedControl *segControl = (UISegmentedControl*)[_addView viewWithTag:115];
        segControl.selectedSegmentIndex = [self.myGoodsState intValue];
    }
    if([keyPath isEqualToString:@"selectedGoods.type"]){
        UILabel *typeLabel =(UILabel*)[_updateView viewWithTag:116];
        typeLabel.text = [NSString stringWithFormat:@"商品类型：     %@",self.selectedGoods ?  self.selectedGoods.type.name:@""];
    }
    
    if([keyPath isEqualToString:@"selectedGoods"])
    {
        
        UILabel *typeLabel =(UILabel*)[_updateView viewWithTag:116];
        typeLabel.text = [NSString stringWithFormat:@"商品类型：     %@",self.selectedGoods ?  self.selectedGoods.type.name:@""];
        UITextField *goodsName =(UITextField*)[_updateView viewWithTag:111];
        goodsName.text = self.selectedGoods.name;
        UITextField *goodsPrice =(UITextField*)[_updateView viewWithTag:112];
        goodsPrice.text =[NSString stringWithFormat:@"%g", self.selectedGoods.price.doubleValue];
        UITextField *goodsCode =(UITextField*)[_updateView viewWithTag:113];
        goodsCode.text = self.selectedGoods.code;
        UITextField *goodsComment =(UITextField*)[_updateView viewWithTag:114];
        goodsComment.text = self.selectedGoods.comment;
        UISegmentedControl *segControl = (UISegmentedControl*)[_updateView viewWithTag:115];
        segControl.selectedSegmentIndex = [self.selectedGoods.state intValue];
        
    }
}

#pragma mark addview methods
-(void)createMyGoodsname:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    _myGoodsName = uf.text;
}

-(void)createMyGoodsPrice:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    NSString * regex        = @"(^[.0-9]{1,15}$)";  
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    BOOL isMatch            = [pred evaluateWithObject:uf.text]; 
    if(isMatch){
        _myGoodsPrice = uf.text;
    }else if(uf.text.length == 0){
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入数字"  delegate:nil cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)createMyGoodsCode:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    NSString * regex        = @"(^[.0-9]{1,15}$)";  
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    BOOL isMatch            = [pred evaluateWithObject:uf.text]; 
    if(isMatch){
        _myGoodsCode = uf.text;
    }else if(uf.text.length == 0){
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入数字"  delegate:nil cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
        [alertView show];
    }

    
}
-(void)createMyGoodsComment:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    _myGoodsComment = uf.text;
}
-(void)createMyGoodsState:(id)sender
{
    UISegmentedControl *s = (UISegmentedControl*)sender;
   _myGoodsState = [NSString stringWithFormat:@"%i", s.selectedSegmentIndex];
}

-(void)selectedGoodsTypes:(id)sender
{
    if(!_popover){
        _popover = [[UIPopoverController alloc] initWithContentViewController:_goodsType];
    }else {
        _popover.contentViewController = _goodsType;
    }
    _goodsType.vc = self;
    _popover.popoverContentSize = CGSizeMake(300, 600);
   [_popover presentPopoverFromRect:[sender frame] inView:_addView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)updateGoodsTypes:(id)sender
{
    if(!_popover){
        _popover = [[UIPopoverController alloc] initWithContentViewController:_goodsType];
    }else {
        _popover.contentViewController = _goodsType;
    }
    _goodsType.vc = self;
    _popover.popoverContentSize = CGSizeMake(300, 600);
    [_popover presentPopoverFromRect:[sender frame] inView:_updateView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)addGoods:(id)sender
{

    
    NSDate *now = [NSDate date];
   now = [[NSDate alloc]initWithTimeInterval:8*60*60 sinceDate:now];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:now];
    
    if(!(self.myGoodsName&&self.myGoodsState&&self.myGoodsCode&&self.myGoodsPrice&&self.myGoodsComment&&self.myGoodsType)){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善商品信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
        
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.myGoodsName,@"name",self.myGoodsState,@"state",self.myGoodsPrice,@"price",[NSNumber numberWithInt:self.myGoodsType.gid.intValue] ,@"type_id", 
                            self.myGoodsCode,@"code",self.myGoodsComment,@"comment",currentDateStr,@"create_time", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    ExproGoods *goods = [ExproGoods object];
    goods.name = self.myGoodsName;
    goods.state = [NSNumber numberWithInt:[self.myGoodsState intValue]];
    goods.price = [NSNumber numberWithDouble: self.myGoodsPrice.doubleValue];
    goods.type = self.myGoodsType;
    goods.code = self.myGoodsCode;
    goods.comment = self.myGoodsComment;
    goods.createTime = now;
    goods.gid =[ NSNumber numberWithInt:-111];
    NSSet *set = [NSSet setWithObject:self.merchant];
    goods.merchants = set;
    [objectManager.objectStore save:nil];
  
    if(!self.goodsManager){
        self.goodsManager = [[exproposGoodsManager alloc]init];
    }
    self.goodsManager.reserver = self;
    self.goodsManager.succeedCallBack = @selector(addGoodsSuccess:);
    self.goodsManager.failedCallBack = @selector(addGoodsFail);
    [self.goodsManager addGoods:params];
    
    
}



-(void)addGoodsSuccess:(id)obj;
{
    NSLog(@"addGoodsSuccess");
    self.myGoodsState =@"1";
    self.myGoodsCode = @"";
    self.myGoodsName = @"";
    self.myGoodsComment = @"";
    self.myGoodsPrice = @"";
    self.myGoodsType = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商品创建成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
  
    ExproGoods *goods = (ExproGoods*)obj;
    NSFetchRequest *req = [ExproGoods fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"gid=%i",-111];
    ExproGoods *g = [[ExproGoods objectsWithFetchRequest:req] objectAtIndex:0];
    NSNumber *gid = goods.gid;
   [goods deleteEntity];
    [[RKObjectManager sharedManager].objectStore save:nil];
    
    g.gid = gid;
   [[RKObjectManager sharedManager].objectStore save:nil];
    
    
    [self loaddata];
    [self.leftView reloadData];
}

-(void)addGoodsFail
{
    NSLog(@"addGoodsFail");
}

#pragma mark updateView methods
-(void)updateMyGoodsname:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    _selectedGoods.name = uf.text;
}

-(void)updateMyGoodsPrice:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    NSString * regex        = @"(^[.0-9]{1,15}$)";  
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    BOOL isMatch            = [pred evaluateWithObject:uf.text]; 
    if(isMatch){
        _selectedGoods.price = [NSNumber numberWithDouble:[uf.text doubleValue]];
    }else if(uf.text.length == 0){
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入数字"  delegate:nil cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

-(void)updateMyGoodsCode:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    NSString * regex        = @"(^[.0-9]{1,15}$)";  
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    BOOL isMatch            = [pred evaluateWithObject:uf.text]; 
    if(isMatch){
         _selectedGoods.code = uf.text;
    }else if(uf.text.length == 0){
        return;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入数字"  delegate:nil cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
        [alertView show];
    }
   
}
-(void)updateMyGoodsComment:(id)sender
{
    UITextField *uf = (UITextField *)sender;
    _selectedGoods.comment = uf.text;
}
-(void)updateMyGoodsState:(id)sender
{
    UISegmentedControl *s = (UISegmentedControl*)sender;
    _selectedGoods.state = [NSNumber numberWithInt: s.selectedSegmentIndex];
}

-(void)updateGoods:(id)sender
{
    if (!self.selectedGoods) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善商品信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if(!self.goodsManager){
        self.goodsManager = [[exproposGoodsManager alloc]init];
    }
    self.goodsManager.reserver = self;
    self.goodsManager.succeedCallBack = @selector(updateGoodsSuccess:);
    self.goodsManager.failedCallBack = @selector(updateGoodsFail);
    [self.goodsManager updateGoods:_selectedGoods];

}

-(void)updateGoodsSuccess:(id)obj
{
    [self loaddata];
    [self.leftView reloadData];
    [self reloads];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)updateGoodsFail
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:@"正确" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark -

-(void)reloads
{
    UILabel *gid =(UILabel*)[_showView viewWithTag:101];
    gid.text = [NSString stringWithFormat:@"编号：                        %i",_selectedGoods.gid.intValue];
    
    UILabel *code =(UILabel*)[_showView viewWithTag:102];
    code.text = [NSString stringWithFormat:@"条形码：                      %@",_selectedGoods?[_selectedGoods code]:@""];
   
    
    UILabel *name = (UILabel*)[_showView viewWithTag:103];
    name.text = [NSString stringWithFormat:@"%@",_selectedGoods?_selectedGoods.name:@""];
   
    
    UILabel *price = (UILabel*)[_showView viewWithTag:104];
    price.text = [NSString stringWithFormat:@"单价：                        %g",_selectedGoods.price.doubleValue];
    
    UILabel *type = (UILabel*)[_showView viewWithTag:105];
    type.text = [NSString stringWithFormat:@"类型：                        %@",_selectedGoods?_selectedGoods.type.name:@""];
    
    UILabel *comment = (UILabel*)[_showView viewWithTag:106];
    comment.text = [NSString stringWithFormat:@"描述：                        %@",_selectedGoods?_selectedGoods.comment:@""];
    
    
}


- (void)goBack:(UIBarButtonItem *)sender {
    [_myRootViewController dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [self setTopView:nil];
    [self setLeftView:nil];
    [self setRightView:nil];
    self.searchData = nil;
    self.allDatas = nil;
    self.datas = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)loaddata
{
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appDelegate.currentUser.gid){
            self.merchant = [member org];
        }
    }
    
    
    NSFetchRequest *request2 = [ExproGoodsType fetchRequest];
    request2.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
    self.allDatas = [[NSArray alloc]initWithArray:[ExproGoodsType objectsWithFetchRequest:request2]];
    
    
    self.datas = [_allDatas mutableCopy];
}


#pragma mark UITableViewDelegate and DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchData == nil){
        int level;
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            level = t.level.intValue;
        }else if([obj isKindOfClass:[ExproGoods class]]){
            ExproGoods *g = (ExproGoods *)obj;
            level = g.type.level.intValue+1;
        }
        return level;
    }
    return 0;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    if(self.searchData == nil){
        return self.datas.count;
    }else {
        return self.searchData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if(indexPath.section ==0){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @" 请选择商品";
        return cell;
    }
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    if(self.searchData == nil){
        CellIdentifier=@"showType";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            cell.textLabel.text = t.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if([obj isKindOfClass:[ExproGoods class]]){
            ExproGoods *g = (ExproGoods *)obj;
            cell.textLabel.text = g.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"unselected.png"];
        }
    }else {
        CellIdentifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        ExproGoods *g = [self.searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = g.code;
        cell.detailTextLabel.text = g.name;
        cell.imageView.image = [UIImage imageNamed:@"unselected.png"];
    }
    
    return cell;
    
    
}

//选择商品时进行的处理
-(void)tableView:(UITableView *)tableView gooddidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return;
    }
    if(self.searchData!=nil){
     self.selectedGoods = [self.searchData objectAtIndex:indexPath.row];
        
    }else {
      self.selectedGoods = [self.datas objectAtIndex:indexPath.row];
  
    }
    
    [self reloads];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
        return ;
    }
    if(self.searchData!=nil){
        [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = [self.datas objectAtIndex:indexPath.row];
    
    BOOL isInserted = NO;
    if([obj isKindOfClass:[ExproGoodsType class]]){
        ExproGoodsType *t = (ExproGoodsType*)obj;
        NSSet *set = t.leaves;
        NSMutableArray *InGoods = [[NSMutableArray alloc] initWithCapacity:20];
         
        for(ExproGoods *g in self.merchant.goods){
            NSLog(@"%i===%i",g.type.gid.intValue,t.gid.intValue);
            if(g.type.gid.intValue == t.gid.intValue){
                [InGoods addObject:g];
            }
        }
        NSLog(@"InGOodscount ==%i",InGoods.count);
        
        for(ExproGoodsType *t in set){
            NSInteger index = [self.datas indexOfObjectIdenticalTo:t];
            isInserted =  (index>0&&index != NSIntegerMax);
            if(isInserted) break;
        }
        for(ExproGoods *g in InGoods){
            NSInteger index = [self.datas indexOfObjectIdenticalTo:g];
            
            isInserted = isInserted || (index>0&&index != NSIntegerMax);
            if(isInserted) break;
        }
        
        
        if(isInserted){
            UITableViewCell *cell = [self.leftView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            
            [self removeGoodsTypes:set Goods:InGoods];
        }else {
            UITableViewCell *cell = [self.leftView cellForRowAtIndexPath:indexPath];
            if(set.count == 0 && InGoods.count == 0){
                cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            }else {
                cell.imageView.image = [UIImage imageNamed:@"descending.png"];
            }
            
            NSUInteger count = indexPath.row+1;
            NSMutableArray *arrCells = [NSMutableArray array];
            for(ExproGoodsType *t  in set){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                [self.datas insertObject:t atIndex:count++];
            }
            for(ExproGoods *g in InGoods){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                [self.datas insertObject:g atIndex:count++];
            }
            
            [tableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }else if([obj isKindOfClass:[ExproGoods class]]){
        [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
    }
    
    
    
    
}
#pragma mark -

-(void)removeGoodsTypes:(NSSet *)types Goods:(NSArray *)goods 
{
    for(ExproGoodsType *t in types){
        
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:t];
        NSSet *set = t.leaves;
        
        NSMutableArray *theGoddsInT = [[NSMutableArray alloc]initWithCapacity:20];
        for(ExproGoods *g in self.merchant.goods){
            if(g.type.gid == t.gid){
                [theGoddsInT addObject:g];
            }
        }
        if(theGoddsInT.count >0 ||(set && set.count>0)){
            [self removeGoodsTypes:set Goods:theGoddsInT];
        }
        if( [self.datas indexOfObjectIdenticalTo:t ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:t];
            [self.leftView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    for(ExproGoods *g in goods){
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:g];
        if( [self.datas indexOfObjectIdenticalTo:g ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:g];
            [self.leftView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}



#pragma mark -


#pragma mark search methods
-(void)reset
{
    
    NSMutableArray *tmpdata = [[NSMutableArray alloc]initWithCapacity:100];
    NSSet *set = [self.merchant goods];
    for(ExproGoods *g in set){
        [tmpdata addObject:g];
    }
    self.searchData = [tmpdata mutableCopy];
    
}

-(void)searchWithNameOrId:(NSString *)nameOrId
{
    [self reset];
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:20];
    for(ExproGoods *good in self.searchData){
        if([good.name rangeOfString:nameOrId ].location == NSNotFound &&
           [good.code rangeOfString:nameOrId].location == NSNotFound)
        {
            [deletes addObject:good];
        }
    }
    
    [self.searchData removeObjectsInArray:deletes];
    [self.leftView reloadData];
}



#pragma mark -
#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length >0){
        [self searchWithNameOrId:searchText];
    }else {
        self.searchData = nil;
        [self.leftView reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchData = nil;
    [self.leftView reloadData];
    [self.searchBar resignFirstResponder];
}

- (IBAction)update:(UIButton *)sender {
    _scrollView.contentOffset = CGPointMake(616*2, 0);
}

- (IBAction)deleteGoods:(UIButton *)sender {
    if (self.selectedGoods == nil) {
        return;
    }
    if(!_goodsManager){
        self.goodsManager = [[exproposGoodsManager alloc]init];
    }
    [self.goodsManager deleteGoods: [NSString stringWithFormat:@"%i",self.selectedGoods.gid.intValue ]];
    self.goodsManager.reserver = self;
    self.goodsManager.succeedCallBack = @selector(deleteGoodsSuccess:);
    self.goodsManager.failedCallBack = @selector(deleteGoodsFail);
}



- (IBAction)add:(UIButton*)sender {
     _scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)deleteGoodsSuccess:(id)obj
{
    NSMutableDictionary *dic = (NSMutableDictionary *)obj;
    int gid = [[dic valueForKey:@"gid"] intValue];
    if(gid != _selectedGoods.gid.intValue){
        [self performSelector:@selector(deleteGoodsFail)];
        return;
    }
    
    
    [_selectedGoods deleteEntity];
    [[RKObjectManager sharedManager].objectStore save:nil];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    self.selectedGoods = nil;
    [self loaddata];
    [self.leftView reloadData];
    [self reloads];
}

-(void)deleteGoodsFail
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除失败 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}



#pragma mark 解决虚拟键盘挡住UITextField的方法


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{       
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.       
    NSTimeInterval animationDuration = 0.30f;       
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];       
    [UIView setAnimationDuration:animationDuration];  
    float width = _scrollView.frame.size.width;               
    float height = _scrollView.frame.size.height;       
    int x = _scrollView.frame.origin.x;
    CGRect rect = CGRectMake(x, _scrollView.frame.origin.y+15, width, height);       
    _scrollView.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;       
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{       
    
   
    NSTimeInterval animationDuration = 0.30f;               
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];               
    [UIView setAnimationDuration:animationDuration];
    float width = _scrollView.frame.size.width;               
    float height = _scrollView.frame.size.height;       
    int x = _scrollView.frame.origin.x;
        CGRect rect = CGRectMake(x,_scrollView.frame.origin.y-15,width,height);               
        self.scrollView.frame = rect;       
          
    [UIView commitAnimations];               
}
#pragma mark -

@end
