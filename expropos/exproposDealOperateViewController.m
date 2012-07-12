//
//  exproposDealOperateViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposDealOperateViewController.h"
#import "ExproMultipleTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "exproposMemberSelectedViewController.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproGoods.h"
#import "exproposMainViewController.h"
#import "exproposGoodSelectedViewController.h"
#import "ExproMultipleTableView.h"
#import "exproposMyTableView.h"
#import "exproposDealOperateMenuViewController.h"
#import "ExproDeal.h"
#import "ExproDealItem.h"
#import "exproposDealOperate.h"
#import "ExproStore.h"
#import "exproposAppDelegate.h"


@interface exproposDealOperateViewController ()

@end

@implementation exproposDealOperateViewController

@synthesize dealItemTableView = _dealItemTableView;
@synthesize scanGoodsView = _scanGoodsView;
@synthesize dealOperateMenu = _dealOperateMenu;
@synthesize mainController = _mainController;
@synthesize mySelectedGoods = _mySelectedGoods;
@synthesize goodsAndAmount = _goodsAndAmount;
@synthesize popover = _popover;
@synthesize member = _member;
@synthesize deal = _deal;
@synthesize operatingDeals = _operatingDeals;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(fromInterfaceOrientation == UIInterfaceOrientationPortrait){
         self.dealItemTableView.frame = CGRectMake(0, 44, 703, 768-44);
        
    }else if(fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.dealItemTableView.frame = CGRectMake(0, 44, 703, 768-44);
    }else {
       self.dealItemTableView.frame =  CGRectMake(0, 44, 768,1024-44);
    }
   [self.dealItemTableView reloadData];
    [self.dealItemTableView setNeedsDisplay];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)refresh
{

    [self reloadDatas];
}
-(void)addToolBarItem
{
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finish:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancels:)];
    UIBarButtonItem *addGoods = [[UIBarButtonItem alloc]initWithTitle:@"添加商品" style:UIBarButtonItemStyleBordered target:self action:@selector(addGoods:)];
    
    NSMutableArray *items = [self.mainController.menuTool.items mutableCopy];
    int index=0;
    BOOL flag = NO;
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"完成"]){
            return;
        }
        if([item.title isEqualToString:@"菜单"]){
            index = 1;
        }
        if([item.title isEqualToString:@"添加商品"]){
            flag = YES;
        }
    }
    if(flag){
        [items insertObject:finish atIndex:index];
        [items insertObject:cancel atIndex:(items.count - 1)];
         self.mainController.menuTool.items = items;
        return;
    }
    [items insertObject:addGoods atIndex:index];
   
    
    self.mainController.menuTool.items = items;
}

-(void)removeSmallToolBarItem
{
    NSMutableArray *items = [self.mainController.menuTool.items mutableCopy];
    NSMutableArray *removeItems = [[NSMutableArray alloc]initWithCapacity:20];
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"完成"]){
            [removeItems addObject:item];
        }
        if([item.title isEqualToString:@"取消"]){
            [removeItems addObject:item];
        }
    }
    if(removeItems.count > 0 ){
        [items removeObjectsInArray:removeItems];
    }
    self.mainController.menuTool.items = items;
    
}

-(void)removeToolBarItem
{
    NSMutableArray *items = [self.mainController.menuTool.items mutableCopy];
    NSMutableArray *removeItems = [[NSMutableArray alloc]initWithCapacity:20];
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"完成"]){
            [removeItems addObject:item];
        }
        if([item.title isEqualToString:@"取消"]){
           [removeItems addObject:item];
        }
        if([item.title isEqualToString:@"添加商品"]){
            [removeItems addObject:item];
        }
    }
    if(removeItems.count > 0 ){
        [items removeObjectsInArray:removeItems];
    }
    self.mainController.menuTool.items = items;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addToolBarItem];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeToolBarItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    _scanGoodsView.layer.borderWidth = 4;
    _scanGoodsView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _dealItemTableView.layer.borderWidth = 1;
    _dealItemTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    _dealItemTableView.multipleDelegate = self;
    _dealItemTableView.multipleDataSource = self;
    [_dealItemTableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    
    _mySelectedGoods = [[NSMutableArray alloc]initWithCapacity:20];
    _goodsAndAmount = [[NSMutableDictionary alloc]initWithCapacity:20];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self                                                         
     selector:@selector(keyboardWillHide:)                                                                 
     name:UIKeyboardWillHideNotification
     object:nil
     ];
   
   }

- (void)viewDidUnload
{
    
    [self setDealItemTableView:nil];
    [self setScanGoodsView:nil];
   
    self.mainController = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark -


-(void)finish:(id)sender
{
    NSLog(@"finish.......");
    int dealGid = 0;
    int dealItemGid = 0;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    //获取应用程序沙盒的Documents目录  
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
    NSString *plistPath1 = [paths objectAtIndex:0];  
    
    //得到完整的文件名  
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"gids.plist"];  

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];  
    if(dic == nil){
        dic = [[NSMutableDictionary alloc]initWithCapacity:20];
    }
    if(dic.count <=0 ){
        [ dic setObject:[NSNumber numberWithInt:0] forKey:@"dealGid"];
        
    }else {
        dealGid = [[dic valueForKey:@"dealGid"] intValue];
        dealItemGid = [[dic valueForKey:@"dealItemGid"] intValue];
    }
    
    
    
    
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
    _deal.type = [NSNumber numberWithInt:1];
    _deal.lid = [NSNumber numberWithInt:(dealGid+1)];
     [dic setValue:[NSNumber numberWithInt:(dealGid+1)] forKey:@"dealGid"];
    _deal.customer = _member;
    _deal.customerID = _member.gid;
    
    int i=0;
    for(ExproGoods *g in _mySelectedGoods){
        
        int amout = [[_goodsAndAmount objectForKey:g.gid] intValue];
        ExproDealItem *dealItem = [ExproDealItem object];
        dealItem.lid = [NSNumber numberWithInt:(dealItemGid+1)];
        dealItem.deal = _deal;
        dealItem.goods = g;
        dealItem.num = [NSNumber numberWithInt:amout];
        dealItem.closingCost = g.price;
        dealItem.totalCost = [NSNumber numberWithDouble:(g.price.doubleValue * amout)];
         [dic setValue:[NSNumber numberWithInt:(dealItemGid+i+1)] forKey:@"dealItemGid"];
        i++;
    }
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appDelegate.currentUser.gid){
            _deal.dealer = member;
            _deal.store =  member.store;
        }
    }
   
    [dic writeToFile:filename atomically:YES];  
    
    [objectManager.objectStore save:nil];
    
   
    _operatingDeals = [[exproposDealOperate alloc]init];
    _operatingDeals.reserver = self;
    _operatingDeals.succeedCallBack = @selector(createDealSuccess:);
    _operatingDeals.failedCallBack = @selector(createDealfail);
    [_operatingDeals createDeal:_deal];
    
   
    
}

-(void)createDealSuccess:(id)object
{
    NSLog(@"success");
    [self cancels:nil];
}

-(void)createDealfail
{
     NSLog(@"fail");
}



-(void)cancels:(id)sender
{
    NSLog(@"cancel........");
    [_mySelectedGoods removeAllObjects];
    [_goodsAndAmount removeAllObjects];
    _member = nil;
    _deal = nil;
    [self removeSmallToolBarItem];
    [self reloadDatas];
}
-(void)addGoods:(id)sender
{
    NSLog(@"addGoods......");
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"goodsSelected"];
    exproposGoodSelectedViewController *goodsSelected = (exproposGoodSelectedViewController *)[nav.viewControllers objectAtIndex:0];
    goodsSelected.viewController = self;
    goodsSelected.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishGoodsSelected)];
   _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    _popover.popoverContentSize = CGSizeMake(300, 400);
    [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)finishGoodsSelected
{
    NSLog(@"finishGoodsSelected....");
    [_popover dismissPopoverAnimated:YES];
}

-(void)reloadDatas
{
    
    [self.dealItemTableView reloadDatas];
    [self.dealOperateMenu.menuTableView reloadData];
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
            if(segment%2==0){
                name.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                name.backgroundColor = [UIColor lightGrayColor];
            }
            name.font = [UIFont systemFontOfSize:12];
            return name;
        }
            break;
        case 1:
        {
            UITextField *amount = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            amount.tag = goods.gid.intValue;
           [amount addTarget:self action:@selector(amoutChanged:) forControlEvents:UIControlEventEditingChanged];
            
            [amount addTarget:self action:@selector(amoutEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
            amount.keyboardType = UIKeyboardTypeNumberPad;
            int amounts = [[_goodsAndAmount objectForKey:goods.gid] intValue];
        
            amount.text = [NSString stringWithFormat:@"%i",amounts];
            if(segment%2==0){
                amount.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                amount.backgroundColor = [UIColor lightGrayColor];
            }
            amount.font = [UIFont systemFontOfSize:12];
            return amount;
        }
            break;
        case 2:
        {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            
            price.text = [NSString stringWithFormat:@"%g", goods.price.doubleValue];
            if(segment%2==0){
                price.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                price.backgroundColor = [UIColor lightGrayColor];
            }
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
            if(segment%2==0){
                subtotal.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                subtotal.backgroundColor = [UIColor lightGrayColor];
            }
            subtotal.font = [UIFont systemFontOfSize:12];
            return subtotal;
        }
            break;
        case 4:
        {
            UILabel *pointer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            pointer.text = @"";
            if(segment%2==0){
                pointer.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
            }else {
                pointer.backgroundColor = [UIColor lightGrayColor];
            }
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
- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorSegment:(NSInteger)segment
{
    if(segment%2==0){
        return [UIColor colorWithWhite:0.75 alpha:1];
    }else {
        return [UIColor lightGrayColor];
    }
}
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)multipleTableView:(ExproMultipleTableView *)tableView
       commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    ExproGoods *goods = [_mySelectedGoods objectAtIndex:row];
    [_goodsAndAmount removeObjectForKey:goods.gid];
    [_mySelectedGoods removeObject:goods];
    [self reloadDatas];
}

-(void)amoutChanged:(id)sender
{
    UITextField *amountField = (UITextField *)sender;
    NSString *amountStr = amountField.text;
    amountStr = [amountStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(amountStr.length > 0){
        int amout = amountStr.intValue;
        ExproGoods *goods = nil;
        for(ExproGoods *g  in _mySelectedGoods){
            if(g.gid.intValue == amountField.tag){
                goods = g;
                if(amout > 0 ){
                    [_goodsAndAmount setObject:[NSNumber numberWithInt:amout] forKey:goods.gid];
                }else {
                    [_goodsAndAmount setObject:[NSNumber numberWithInt:1] forKey:goods.gid];
                }
            }
        }
        
//        [self reloadDatas];
    }
    
}
-(void)amoutEnd:(id)sender
{
    
    [self performSelector:@selector(reloadDatas) withObject:nil afterDelay:0.01];
    
 
}
- (void) keyboardWillHide:(NSNotification *)note
{
    [self performSelector:@selector(reloadDatas) withObject:nil afterDelay:0.01];
}

 
@end
