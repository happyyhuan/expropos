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


@interface exproposDealOperateViewController ()

@end

@implementation exproposDealOperateViewController
@synthesize menuTableView = _menuTableView;
@synthesize dealItemTableView = _dealItemTableView;
@synthesize scanGoodsView = _scanGoodsView;
@synthesize popover = _popover;
@synthesize memberSelected = _memberSelected;
@synthesize member = _member;

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
	_menuTableView.layer.borderWidth = 4;
    _menuTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    
    _scanGoodsView.layer.borderWidth = 4;
    _scanGoodsView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _dealItemTableView.layer.borderWidth = 4;
    _dealItemTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
}

- (void)viewDidUnload
{
    [self setMenuTableView:nil];
    [self setDealItemTableView:nil];
    [self setScanGoodsView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark menuTableView delegate and dataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
     UITableViewCell *cell = nil;
    
    if(section == 0){
        if(row == 0){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            cell.imageView.image = [UIImage imageNamed:@"member.png"];
            cell.textLabel.text = @"匿名用户";
            cell.detailTextLabel.text = @"非会员";
        }else {
            if(row == 1){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"电话：";
            }
            if(row == 2){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"储值：¥0";
            }
            if(row == 3){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"积分：0";
            }
        }
    }
        
        if(section == 1){
            if(row == 0){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"应收：¥125";
            }
            if(row == 1){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"实收：¥";
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90, cell.bounds.size.height/4, 70, cell.bounds.size.height/2)];
                [textField setBackgroundColor:[UIColor lightGrayColor]];
                textField.borderStyle = UITextBorderStyleLine;
                textField.keyboardType =UIKeyboardTypeNumberPad;
                [cell addSubview:textField];
            }
            if(row == 2){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"找零：¥";
            }

        
        }
    if (section == 2) {
        if(row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"总计：";
            cell.detailTextLabel.text = @"¥1200";
            
        }
        if(row == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"数量：";
            cell.detailTextLabel.text = @"24";
            
        }
        if(row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"结算：";
            NSArray *payTypes = [NSArray arrayWithObjects:@"现金",@"存储卡", nil];
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:payTypes];
            seg.frame = CGRectMake(70, cell.bounds.size.height/6, 98, cell.bounds.size.height*2/3);
            [seg addTarget:self  action:@selector(payTypeSelected:) forControlEvents:UIControlEventValueChanged];
            seg.selectedSegmentIndex = 0;
            [cell addSubview:seg];
            
        }
        
        if(row == 3){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"积分消费";
            UISwitch *switchs = [[UISwitch alloc] initWithFrame:CGRectMake(90,  cell.bounds.size.height/5, 80, cell.bounds.size.height)];
            switchs.On = YES;
            [switchs addTarget:self action:@selector(integralOperate:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchs];
        }
        if(row == 4){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"优惠券";
            UISwitch *switchs = [[UISwitch alloc] initWithFrame:CGRectMake(90, cell.bounds.size.height/5, 80, cell.bounds.size.height)];
            switchs.On = YES;
            [switchs addTarget:self action:@selector(couponOperate:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchs];
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"memberSelect"];
            _memberSelected = [nav.viewControllers objectAtIndex:0];
            _memberSelected.viewController = self;
            _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
            CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
            [_popover presentPopoverFromRect:popoverRect
                                      inView:cell //上面的矩形坐标是以这个view为参考的
                    permittedArrowDirections:UIPopoverArrowDirectionAny //箭头方向
                                    animated:YES];
        
    }
}

#pragma mark -

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
     NSArray *payTypes = [NSArray arrayWithObjects:@"现金",@"存储卡", nil];
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int index = seg.selectedSegmentIndex;
    NSLog(@"%@",[payTypes objectAtIndex:index]);
}
@end
