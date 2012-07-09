//
//  exproposDealOperateMenuViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposDealOperateMenuViewController.h"
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
#import "exproposDealOperateViewController.h"
#import "ExproDeal.h"


@interface exproposDealOperateMenuViewController ()

@end

@implementation exproposDealOperateMenuViewController
@synthesize menuTableView = _menuTableView;
@synthesize popover = _popover;
@synthesize memberSelected = _memberSelected;
@synthesize dealOperate = _dealOperate;
@synthesize getMeony = _getMeony;



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
	
    _menuTableView.myTableViewDelegate = self;
    _menuTableView.myTableViewDataSource = self;
    self.contentSizeForViewInPopover = CGSizeMake(300, 400);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view
    self.memberSelected = nil;
    [self setMenuTableView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark menuTableView delegate and dataSource Methods
-(NSInteger)numberOfSectionsInMyTableView:(exproposMyTableView *)tableView
{
    return 3;
}

-(NSInteger)myTableView:(exproposMyTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 4;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        return 5;
    }
    
    
    return 0;
}

-(UITableViewCell*)myTableView:(exproposMyTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    UITableViewCell *cell = nil;
    
    if(section == 0){
        if(row == 0){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            cell.imageView.image = [UIImage imageNamed:@"member.png"];
            if(self.dealOperate.member == nil){
                cell.textLabel.text = @"匿名用户";
                cell.detailTextLabel.text = @"非会员";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else {
                cell.textLabel.text = self.dealOperate.member.petName;
                cell.detailTextLabel.text = @"普通会员";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            
        }else {
            if(row == 1){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                if(self.dealOperate.member == nil){
                    cell.textLabel.text = @"电话:";
                }else {
                    NSString *str = [NSString stringWithFormat:@"电话:%@",self.dealOperate.member.user.cellphone];
                    cell.textLabel.text = str;
                }
                
            }
            if(row == 2){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                NSString *str = [NSString stringWithFormat:@"储值：¥%g",self.dealOperate.member.savings.doubleValue];
                cell.textLabel.text = str;
            }
            if(row == 3){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                NSString *str = [NSString stringWithFormat:@"积分：%g",self.dealOperate.member.point.doubleValue];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.text = str;
            }
        }
    }
    
    if(section == 1){
        if(row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"应收：";
           if(self.dealOperate.goodsAndAmount == nil){
                
                cell.detailTextLabel.text = @"¥0";
            }else {
                double sum = 0.0;
                for(ExproGoods *g in self.dealOperate.mySelectedGoods){
                    int amout = [[self.dealOperate.goodsAndAmount objectForKey:g.gid] intValue];
                    sum += g.price.doubleValue * amout;
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%g",sum];
            }
           
        }
        if(row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"实收：¥";
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(200, cell.bounds.size.height/6, 90, 2*cell.bounds.size.height/3)];
            
            textField.text =[NSString stringWithFormat:@"%g", _getMeony];
            [textField setBackgroundColor:[UIColor lightGrayColor]];
            textField.borderStyle = UITextBorderStyleLine;
            textField.keyboardType =UIKeyboardTypeNumberPad;
            [textField addTarget:self action:@selector(getMeonyChanged:) forControlEvents:UIControlEventEditingChanged];
            [textField addTarget:self action:@selector(getMeonyEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell addSubview:textField];
        }
        if(row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if(_getMeony > 0){
                double sum = 0.0;
                for(ExproGoods *g in self.dealOperate.mySelectedGoods){
                    int amout = [[self.dealOperate.goodsAndAmount objectForKey:g.gid] intValue];
                    sum += g.price.doubleValue * amout;
                }
                cell.textLabel.text =[NSString stringWithFormat:@"找零：¥%g",(_getMeony - sum) ] ;
            }else {
                cell.textLabel.text = @"找零：¥0";
            }
        }
        
        
    }
    if (section == 2) {
        if(row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"总计：";
            double sum = 0.0;
            
            if(self.dealOperate.goodsAndAmount == nil){
                cell.detailTextLabel.text = @"¥0";
            }else {
                for(ExproGoods *g in self.dealOperate.mySelectedGoods){
                    int amout = [[self.dealOperate.goodsAndAmount objectForKey:g.gid] intValue];
                    sum += g.price.doubleValue * amout;
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%g",sum];
            }
            
            
        }
        if(row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"数量：";
            if(self.dealOperate.goodsAndAmount != nil){
                int amout = 0;
                for(ExproGoods *g in self.dealOperate.mySelectedGoods){
                     amout += [[self.dealOperate.goodsAndAmount objectForKey:g.gid] intValue];
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",amout];
            }else {
                cell.detailTextLabel.text = @"0";
            }
        }
        if(row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"结算：";
            NSArray *payTypes = [NSArray arrayWithObjects:@"现金",@"存储卡", nil];
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:payTypes];
            seg.frame = CGRectMake(200, cell.bounds.size.height/6, 110, cell.bounds.size.height*2/3);
            [seg addTarget:self  action:@selector(payTypeSelected:) forControlEvents:UIControlEventValueChanged];
            seg.selectedSegmentIndex = 0;
            [cell addSubview:seg];
            
        }
        
        if(row == 3){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"积分消费";
            UISwitch *switchs = [[UISwitch alloc] initWithFrame:CGRectMake(230,  cell.bounds.size.height/5, 80, cell.bounds.size.height)];
            switchs.On = YES;
            [switchs addTarget:self action:@selector(integralOperate:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchs];
        }
        if(row == 4){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"优惠券";
            UISwitch *switchs = [[UISwitch alloc] initWithFrame:CGRectMake(230, cell.bounds.size.height/5, 80, cell.bounds.size.height)];
            switchs.On = YES;
            [switchs addTarget:self action:@selector(couponOperate:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchs];
        }
        
    }
    return cell;
}

-(void)myTableView:(exproposMyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"memberSelect"];
        _memberSelected = [nav.viewControllers objectAtIndex:0];
        _memberSelected.viewController = self.dealOperate;
        _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
        _popover.popoverContentSize = CGSizeMake(300, 400);
        self.memberSelected.popover = _popover;
        [_popover presentPopoverFromRect:popoverRect
                                  inView:cell //上面的矩形坐标是以这个view为参考的
                permittedArrowDirections:UIPopoverArrowDirectionAny //箭头方向
                                animated:YES];
        
    }
}

#pragma mark -

-(void)getMeonyChanged:(id)sender
{
    UITextField *filed = (UITextField *)sender;
    NSString *filedStr = filed.text;
    filedStr = [filedStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(filedStr.length > 0){
        double menoy = filedStr.doubleValue;
        if(menoy > 0){
            _getMeony = menoy;
        }else {
            _getMeony = 0.0;
        }
    }
}
-(void)getMeonyEnd
{
    [self.menuTableView reloadData];
}


-(void)integralOperate:(id)sender
{
    UISwitch *s = (UISwitch*)sender;
    NSLog(@"%i",s.isOn);
}
-(void)couponOperate:(id)sender
{
    UISwitch *s = (UISwitch*)sender;
    NSLog(@"%i",s.isOn);
}
-(void)payTypeSelected:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int index = seg.selectedSegmentIndex;
    if(self.dealOperate.deal == nil){
        self.dealOperate.deal = [ExproDeal object];
    }
    self.dealOperate.deal.payType = [NSNumber numberWithInt:index];
}

@end
