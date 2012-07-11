//
//  exproposMemberRegisterController.m
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMemberRegisterController.h"
#import "exproposDateSelectedViewController.h"
#import "exproposLeverSelectViewController.h"

@interface exproposMemberRegisterController ()

@end


@implementation exproposMemberRegisterController


@synthesize viewController = _viewController;

@synthesize firstName =_firstName;

@synthesize birth =_birth;
@synthesize lastName = _lastName;
@synthesize telphone =_telphone;
@synthesize levelItem=_levelItem;
@synthesize popover = _popover;

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
    _telphone = @"";
    _firstName = @"";
    _lastName = @"";
    _levelItem = [[NSMutableArray alloc] initWithCapacity:20];
    _birth = [NSDate date];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return  3 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    
    if(section == 1){
        return 4;
    }
    
    return 2;
       
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

        if(indexPath.section ==0 && indexPath.row == 0){
            
            UITextField *telField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:telField];
            [telField setBackgroundColor:[UIColor whiteColor]];
            cell.textLabel.text = NSLocalizedString(@"手机", nil);
            cell.detailTextLabel.text = @"必须填写";
            [telField setBackgroundColor:[UIColor whiteColor]];
            telField.borderStyle = UITextBorderStyleRoundedRect;
            telField.textAlignment = UITextAlignmentLeft;
            telField.text = self.telphone;
            telField.tag = 1;
            telField.delegate = self;
            telField.keyboardType = UIKeyboardTypeNumberPad;
            [telField addTarget:self action:@selector(saveFromTelField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if( indexPath.section == 1 ){
        

        if (indexPath.row == 0)
        {
            UITextField *firstFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:firstFieldField];
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            
            cell.textLabel.text = NSLocalizedString(@"姓", nil);
            cell.detailTextLabel.text = @"必须填写";
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            firstFieldField.borderStyle = UITextBorderStyleRoundedRect;
            firstFieldField.textAlignment = UITextAlignmentLeft;
            firstFieldField.text = self.firstName;
            firstFieldField.tag = 1;
            firstFieldField.delegate = self;
            firstFieldField.keyboardType = UIKeyboardTypeNumberPad;
            [firstFieldField addTarget:self action:@selector(saveFromFirstNameField:) forControlEvents:UIControlEventEditingChanged];
        }
        if (indexPath.row == 1)
        {
            UITextField *firstFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:firstFieldField];
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            
            cell.textLabel.text = NSLocalizedString(@"名", nil);
            
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            firstFieldField.borderStyle = UITextBorderStyleRoundedRect;
            firstFieldField.textAlignment = UITextAlignmentLeft;
            firstFieldField.text = self.firstName;
            firstFieldField.tag = 1;
            firstFieldField.delegate = self;
            firstFieldField.keyboardType = UIKeyboardTypeNumberPad;
            [firstFieldField addTarget:self action:@selector(saveFromLastNameField:) forControlEvents:UIControlEventEditingChanged];
        }
        if (indexPath.row == 2)
        {
            cell.textLabel.text = @"生日";
            if([[self dateToString:self.birth] isEqualToString: [self dateToString:[NSDate date]]]){
                cell.detailTextLabel.text = @"今天";
            }else {
                cell.detailTextLabel.text = [self dateToString:self.birth];
            }    
        }
        if (indexPath.row == 3)
        {
            cell.textLabel.text = @"先生：";
            NSArray *payTypes = [NSArray arrayWithObjects:@"on",@"off", nil];
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:payTypes];
            seg.frame = CGRectMake(300, cell.bounds.size.height/6, 110, cell.bounds.size.height*2/3);
//            [seg addTarget:self  action:@selector(payTypeSelected:) forControlEvents:UIControlEventValueChanged];
            seg.selectedSegmentIndex = 0;
            [cell addSubview:seg];
        }
    
   }else if(indexPath.section == 2){
       
        if(indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"会员等级";
            if(self.levelItem.count == 0){
                cell.detailTextLabel.text= @"所有等级";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                NSArray *dealItemTitles = [NSArray arrayWithObjects:@"消费撤",@"消费",@"充值",@"充值撤销",@"积分增加",@"积分消费",@"积分撤销",@"退货退款",@"抽奖",@"手工调整", nil];
                for(NSNumber *i in self.levelItem){
                    [message appendFormat:@"%@,",[dealItemTitles objectAtIndex:i.intValue]];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }
            
        }else if(indexPath.row ==1 ){           
            cell.textLabel.text = @"储值帐户：";
            NSArray *payTypes = [NSArray arrayWithObjects:@"on",@"off", nil];
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:payTypes];
            seg.frame = CGRectMake(300, cell.bounds.size.height/6, 110, cell.bounds.size.height*2/3);
//            [seg addTarget:self  action:@selector(payTypeSelected:) forControlEvents:UIControlEventValueChanged];
            seg.selectedSegmentIndex = 0;
            [cell addSubview:seg];      
        }
    }    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    
    if(indexPath.section == 1 && indexPath.row ==2){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
        exproposDateSelectedViewController *dateSelect = (exproposDateSelectedViewController *)controller;
        dateSelect.viewController = self;
        if(indexPath.row == 0){
            dateSelect.isBegin = YES;
        }
        if (_popover == nil) {
            _popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        }else {
            _popover.contentViewController = controller;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self showOrderNumPopover:cell];
    }   
    if (indexPath.section ==2 && indexPath.row == 0)
    {
        exproposLeverSelectViewController *levelItemSelect = [[exproposLeverSelectViewController alloc]init];
        levelItemSelect.viewController = self;
        [self.navigationController pushViewController:levelItemSelect animated:YES];
    }
    
}

-(void)showOrderNumPopover:(UITableViewCell *)cell {
    //弹出窗口大小，如果屏幕画不下，会挤小的。这个值默认是320x1100
    //_popover.popoverContentSize = CGSizeMake(300, 216);
    //popoverRect的中心点是用来画箭头的，如果中心点如果出了屏幕，系统会优化到窗口边缘
    CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
    [_popover presentPopoverFromRect:popoverRect
                              inView:cell //上面的矩形坐标是以这个view为参考的
            permittedArrowDirections:UIPopoverArrowDirectionUp //箭头方向
                            animated:YES];
}



-(NSString *)dateToString:(NSDate*)date
{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27
    return dateStr;
}
-(void)saveFromFirstNameField:(NSString *)firstFieldText
{
    self.firstName = firstFieldText;
}
-(void)saveFromLastNameField:(NSString *)lastFieldText
{
    self.lastName = lastFieldText;
}
-(void)saveFromTelField:(NSString *)telText
{
    self.telphone = telText;
}

@end
