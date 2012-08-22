//
//  exproposNumKeyboard.m
//  expropos
//
//  Created by haitao chen on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposNumKeyboard.h"
#import "JPStupidButton.h"
#import "exproposShowDealOperateViewController.h"
#import "ExproGoods.h"
#import "ExproDeal.h"
#import "ExproDealItem.h"

@interface exproposNumKeyboard ()

@end

@implementation exproposNumKeyboard
@synthesize popover = _popover;
@synthesize viewController = _viewController;
@synthesize goodsNum = _goodsNum;
@synthesize deleteOneNum = _deleteOneNum;
@synthesize keys = _keys;
@synthesize goods = _goods;

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
	for(JPStupidButton *button in _keys){
        button.buttonClickDelegate = self;
    }
}

-(void)touch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if([button.titleLabel.text isEqualToString:@"取消"]){
        [_popover dismissPopoverAnimated:YES];
        if(  [_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
            exproposShowDealOperateViewController *showDealOperate = (exproposShowDealOperateViewController*)_viewController;
            showDealOperate.view.alpha = 1;
            NSMutableArray *array = [NSMutableArray arrayWithArray:showDealOperate.buttons];
            [array insertObject:showDealOperate.deleteButton atIndex:0];
            _popover.passthroughViews = array;
        }
        return;
    }
    if([button.titleLabel.text isEqualToString:@"确定"]){
        if(  [_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
            exproposShowDealOperateViewController *showDealOperate = (exproposShowDealOperateViewController*)_viewController;
            if(showDealOperate.repeal){
                ExproDealItem *dealItem = nil;
                for(ExproDealItem *item in  showDealOperate.repeal.items){
                    if(item.goods.gid.intValue == _goods.gid.intValue){
                        dealItem = item;
                    }
                }
                
                if(_goodsNum.text.intValue > dealItem.num.intValue){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message: @"退货数量不能大于购买数量 " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            
            
            
           int num = _goodsNum.text.intValue;
            [showDealOperate.goodsAndAmount setObject:[NSNumber numberWithInt:num] forKey:_goods.gid];
            [showDealOperate reloadViews];
            showDealOperate.view.alpha = 1;
            NSMutableArray *array = [NSMutableArray arrayWithArray:showDealOperate.buttons];
            [array insertObject:showDealOperate.deleteButton atIndex:0];
            _popover.passthroughViews = array;
            [_popover dismissPopoverAnimated:YES];
        }
        return;
    }
    NSString * str = _goodsNum.text;
    NSString *newStr = [NSString stringWithFormat:@"%@%@",str,button.titleLabel.text];
    _goodsNum.text = newStr;

}


- (void)viewDidUnload
{
    [self setGoodsNum:nil];
    [self setDeleteOneNum:nil];
    [self setKeys:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deleteOneGoodsNum:(id)sender {
    NSString *str = _goodsNum.text;
    
    if(str.length == 0){
        return;
    }else {
        _goodsNum.text =[ str substringToIndex:str.length-1 ];
    }
}
@end
