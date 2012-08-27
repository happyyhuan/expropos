//
//  exproposPayViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposPayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "exproposShowDealOperateViewController.h"
#import "JPStupidButton.h"

@interface exproposPayViewController ()

@end

@implementation exproposPayViewController
@synthesize haveGetMoney = _haveGetMoney;
@synthesize mykeyboards = _mykeyboards;
@synthesize shouleGetMoney = _shouleGetMoney;
@synthesize getRealMoney = _getRealMoney;
@synthesize keyboards = _keyboards;
@synthesize mainView = _mainView;
@synthesize showOperate = _showOperate;
@synthesize shouldPopMoney = _shouldPopMoney;

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
    _shouleGetMoney .layer.cornerRadius = 10.0;
    _shouleGetMoney .layer.masksToBounds = YES;
	_shouleGetMoney.layer.borderWidth = 3;
    _shouleGetMoney.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _getRealMoney .layer.cornerRadius = 10.0;
    _getRealMoney .layer.masksToBounds = YES;
	_getRealMoney.layer.borderWidth = 3;
    _getRealMoney.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    _keyboards .layer.cornerRadius = 10.0;
    _keyboards .layer.masksToBounds = YES;
	_keyboards.layer.borderWidth = 3;
    _keyboards.layer.borderColor = [[UIColor grayColor] CGColor];

    self.view.layer.borderWidth = 3;
    self.view.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _shouleGetMoney.text = [NSString stringWithFormat:@"应收：¥%@",_showOperate.allGoodsPayments.text];
    _shouldPopMoney.text = @"¥0";
    for(JPStupidButton *button in _mykeyboards){
        button.buttonClickDelegate = self;
    }
    
    [_haveGetMoney addTarget:self action:@selector(deleteKeyboard:) forControlEvents:UIControlEventEditingDidBegin];
}

-(void)deleteKeyboard:(id)sender
{
    UITextField *f = (UITextField*)sender;
    [f resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setShouleGetMoney:nil];
    [self setGetRealMoney:nil];
    [self setKeyboards:nil];
    [self setMainView:nil];
    [self setShouldPopMoney:nil];
    [self setHaveGetMoney:nil];
    [self setMykeyboards:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)payTypeChanged:(UISegmentedControl *)seg {
    
}

-(void)touch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    if([title isEqualToString:@"."]){
        if(_haveGetMoney.text.length == 0){
            return;
        }
    }
    if([title isEqualToString:@"C"]){
        if(_haveGetMoney.text.length==0){
            return;
        }
         _haveGetMoney.text =[NSString stringWithFormat:@"%@", [_haveGetMoney.text substringToIndex:_haveGetMoney.text.length-1]];
        
    }else {
          _haveGetMoney.text =[NSString stringWithFormat:@"%@%@", _haveGetMoney.text,title];
    }
  
    _shouldPopMoney.text = [NSString stringWithFormat:@"¥%g",(_haveGetMoney.text.doubleValue - _showOperate.allGoodsPayments.text.doubleValue)];
}

- (IBAction)finish:(id)sender {
    if(_haveGetMoney.text.doubleValue < _showOperate.allGoodsPayments.text.doubleValue){
        return;
    }
    [_showOperate finish];
    [_showOperate dismissModalViewControllerAnimated:YES];
}
@end
