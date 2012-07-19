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

#import "exproposRegistr.h"

#import "exproposValidater.h"
#import "ExproMember.h"
#import "exproposPrivacyController.h"
#import "ExproUser.h"
 

@interface exproposMemberRegisterController ()
@property (strong) exproposRegistr *registr;
@property (strong) exproposValidater *validate;

@end


@implementation exproposMemberRegisterController

@synthesize mainViewController = _mainViewController;
@synthesize viewController = _viewController;

@synthesize name =_name;

@synthesize birth =_birth;
@synthesize petName= _petName;
@synthesize telphone =_telphone;
@synthesize levelItem=_levelItem;
@synthesize idCard =_idCard;
@synthesize email =_email;
@synthesize comment =_comment;
@synthesize popover = _popover;
@synthesize sex=_sex;
@synthesize account=_account;
@synthesize registr =_registr;
@synthesize validate=_validate;
@synthesize status=_status;

@synthesize memPetName=_memPetName;
@synthesize savings=_savings;
@synthesize createTime=_createTime;
@synthesize dueTime=_dueTime;
@synthesize privacyItem=_privacyItem;
@synthesize point=_point;
@synthesize dateSel=_dateSel;


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
    _name = @"";
    _petName = @"";
    _idCard =@"";
    _email = @"";
    _comment =@"";
    _levelItem = [[NSMutableArray alloc] initWithCapacity:20];
    _birth = [NSDate date];
    _savings=@"";
    _createTime =[NSDate date];
    _dueTime = [NSDate date];
    _privacyItem = [[NSMutableArray alloc] initWithCapacity:20];
    _dateSel = @"";
    _sex =@"0";
    _memPetName=@"";
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _telphone = nil;
    _name = nil;
    _petName = nil;
    _idCard =nil;
    _email = nil;
    _comment =nil;
    // Release any retained subviews of the main view.
}


-(void)viewWillAppear:(BOOL)animated
{
//    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.mainViewController.menuTool.items mutableCopy]];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style: UIBarButtonItemStyleBordered   target:self action:@selector(registr:)];
//    int num = 0;
//    for(UIBarButtonItem *i in items){
//        if([i.title isEqualToString:@"菜单"]){
//            num = 1;
//        }
//    }
//    [items insertObject:item atIndex:num];
//    self.mainViewController.menuTool.items = items;
}

-(void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.mainViewController.menuTool.items mutableCopy]];
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"注册"]){
            [removeItems addObject: item]; 
        }   
    }
    [items removeObjectsInArray:removeItems];
    self.mainViewController.menuTool.items = items;
}

-(void)registr:(UIBarButtonItem *)sender
{
    if (202 == self.status.intValue)
    {
        NSString *warning = nil;

        if (self.name.length == 0 ) {
            warning = NSLocalizedString(@"请输入姓", nil);
        }
        if (warning) 
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:warning 
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            self.registr = [[exproposRegistr alloc]init];
            _registr.reserver = self;
            _registr.succeedCallBack = @selector(registrSucceed:);            
            [_registr registr:self.telphone name:self.name petName:self.petName email:self.email
                       idCard:self.idCard comment:self.comment  sex:self.sex  
                       saving:self.savings point:self.point dueTime:[self dateToString:self.dueTime]
                        birth:[self dateToString:self.birth]
                        memPetName:self.memPetName];
        }
    }
    else if (404 == self.status.intValue)//关联用户到商户
    {
        self.registr = [[exproposRegistr alloc]init];
        _registr.reserver = self;
        _registr.succeedCallBack = @selector(registrSucceed:);
        [_registr registr:self.telphone name:self.name petName:self.petName email:self.email
                   idCard:self.idCard comment:self.comment  sex:self.sex  
                   saving:self.savings point:self.point dueTime:[self dateToString:self.dueTime]
                    birth:[self dateToString:self.birth]
                     memPetName:self.memPetName];
    }
}

- (void) registrSucceed:(id)object {
    
//    ExproMember *member = object;
//    int64_t gid = member.gid.unsignedLongLongValue;
//    NSLog(@"id:%qu ", member.gid.unsignedLongLongValue);
//    
//    if (gid) {
//        ExproMember *result = [ExproMember objectWithPredicate:[NSPredicate predicateWithFormat:@"gid=%qu",gid]];
//        if (result) {
//            NSLog(@"%@",result.petName);
//            ExproUser *user = result.user;
//            if (user) {
//                NSLog(@"%@",user.cellphone);
//            }
//            else {
//                NSLog(@"No user");
//            }
//        }
//        else {
//            NSLog(@"not found");
//        }
// 
//    }
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:@"用户注册成功" 
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    
    [alert show];    
    self.telphone = nil;
    self.name = nil;
    self.petName = nil;
    self.email = nil;
    self.idCard = nil;
    self.comment =nil;
    self.savings =nil;
    self.point =nil;
    self.dueTime=[NSDate date];
    self.birth=[NSDate date];
    self.privacyItem=nil;
    self.memPetName = nil;
    [self.tableView reloadData];
    
    //[super viewWillDisappear:animated];
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.mainViewController.menuTool.items mutableCopy]];
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"注册"]){
            [removeItems addObject: item]; 
        }   
    }
    [items removeObjectsInArray:removeItems];
    self.mainViewController.menuTool.items = items;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (202 == self.status.intValue )
    {
        return  3 ;
    }
    else if (404 == self.status.intValue || 405 == self.status.intValue){
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (202 == self.status.intValue)
    {
        if(section == 0){
            return 1;
        }
        if(section == 1){
            return 7;
        }
        return 5;
    }
    else {
        if(section == 0){
            return 1;
        }
        else {
              return 5;
        }
    }
   
    return 0;       
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    //}
    if(indexPath.section ==0 && indexPath.row == 0){
            
            UITextField *telField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:telField];
            
           [telField setBackgroundColor:[UIColor whiteColor]];
            cell.textLabel.text = NSLocalizedString(@"手机", nil);       
            UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(600, 10, 50, 25)];
            [myButton setTitle:@"下一步" forState:UIControlStateNormal]; 
            [myButton setBackgroundColor:[UIColor grayColor]];
            [myButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
            [myButton setFont:[UIFont systemFontOfSize:12]];     
            [cell addSubview:myButton];
            [telField setBackgroundColor:[UIColor whiteColor]];
            telField.borderStyle = UITextBorderStyleRoundedRect;
            telField.textAlignment = UITextAlignmentLeft;
            telField.text = self.telphone;
            telField.tag = 1;
            telField.delegate = self;
            telField.keyboardType = UIKeyboardTypeNumberPad;
            [telField addTarget:self action:@selector(saveFromTelField:) forControlEvents:UIControlEventEditingChanged];
    }
    else if( indexPath.section == 1 )
    {
        
        if (202 == self.status.intValue)
        {
            if (indexPath.row == 0)
            {
                NSLog(@"self.status == %@",self.status);
            
            UITextField *firstFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:firstFieldField];
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            
            cell.textLabel.text = NSLocalizedString(@"姓名", nil);
            cell.detailTextLabel.text = @"必须填写";
            [firstFieldField setBackgroundColor:[UIColor whiteColor]];
            firstFieldField.borderStyle = UITextBorderStyleRoundedRect;
            firstFieldField.textAlignment = UITextAlignmentLeft;
            firstFieldField.text = self.name;
            firstFieldField.tag = 1;
                
            firstFieldField.delegate = self;
            firstFieldField.keyboardType = UIKeyboardTypeDefault;
            [firstFieldField addTarget:self action:@selector(saveFromFirstNameField:) forControlEvents:UIControlEventEditingChanged];
           
            }
            if (indexPath.row == 1)
            {
           
            UITextField *petFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
            [cell addSubview:petFieldField];
            [petFieldField setBackgroundColor:[UIColor whiteColor]];
            
            cell.textLabel.text = NSLocalizedString(@"昵称", nil);
            
            [petFieldField setBackgroundColor:[UIColor whiteColor]];
            petFieldField.borderStyle = UITextBorderStyleRoundedRect;
            petFieldField.textAlignment = UITextAlignmentLeft;
            petFieldField.text = self.petName;
            petFieldField.tag = 1;
            petFieldField.delegate = self;
            petFieldField.keyboardType = UIKeyboardTypeDefault;
            [petFieldField addTarget:self action:@selector(saveFromLastNameField:) forControlEvents:UIControlEventEditingChanged];
            
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
                    [seg addTarget:self  action:@selector(sexSelect:) forControlEvents:UIControlEventValueChanged];
                    seg.selectedSegmentIndex = 0;
                    [cell addSubview:seg];
                    cell.detailTextLabel.text = @"";
                
            }
            if (indexPath.row == 4)
            {
                
                UITextField *idCardField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:idCardField];
                [idCardField setBackgroundColor:[UIColor whiteColor]];
                
                cell.textLabel.text = NSLocalizedString(@"身份证", nil);
                
                [idCardField setBackgroundColor:[UIColor whiteColor]];
                idCardField.borderStyle = UITextBorderStyleRoundedRect;
                idCardField.textAlignment = UITextAlignmentLeft;
                idCardField.text = self.idCard;
                idCardField.tag = 1;
                idCardField.delegate = self;
                idCardField.keyboardType = UIKeyboardTypeNumberPad;
                [idCardField addTarget:self action:@selector(saveIdCardField:) forControlEvents:UIControlEventEditingChanged];
                cell.detailTextLabel.text = @"";

            }

            if (indexPath.row == 5)
            {
                
                UITextField *emailField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:emailField];
                [emailField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"电子邮件", nil);
                [emailField setBackgroundColor:[UIColor whiteColor]];
                emailField.borderStyle = UITextBorderStyleRoundedRect;
                emailField.textAlignment = UITextAlignmentLeft;
                emailField.text = self.email;
                emailField.tag = 1;
                emailField.delegate = self;
                emailField.keyboardType = UIKeyboardTypeEmailAddress;
                [emailField addTarget:self action:@selector(saveEmailField:) forControlEvents:UIControlEventEditingChanged];                
            }

            if (indexPath.row == 6)
            {
                
                UITextField *commentField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:commentField];
                [commentField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"备注", nil);
                [commentField setBackgroundColor:[UIColor whiteColor]];
                commentField.borderStyle = UITextBorderStyleRoundedRect;
                commentField.textAlignment = UITextAlignmentLeft;
                commentField.text = self.comment;
                commentField.tag = 1;
                commentField.delegate = self;
                commentField.keyboardType = UIKeyboardTypeDefault;
                [commentField addTarget:self action:@selector(saveCommentField:) forControlEvents:UIControlEventEditingChanged];
            }
        }
        else {
            if (indexPath.row ==0)
            {
                UITextField *memPetNameFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:memPetNameFieldField];
                [memPetNameFieldField setBackgroundColor:[UIColor whiteColor]];
                
                cell.textLabel.text = NSLocalizedString(@"会员昵称（商户）", nil);
                cell.detailTextLabel.text = @"必须填写";
                [memPetNameFieldField setBackgroundColor:[UIColor whiteColor]];
                memPetNameFieldField.borderStyle = UITextBorderStyleRoundedRect;
                memPetNameFieldField.textAlignment = UITextAlignmentLeft;
                memPetNameFieldField.text = self.memPetName;
                memPetNameFieldField.tag = 1;
                memPetNameFieldField.delegate = self;
                memPetNameFieldField.keyboardType = UIKeyboardTypeDefault;
                [memPetNameFieldField addTarget:self action:@selector(saveMemPetNameField:) forControlEvents:UIControlEventEditingChanged];
                

            }
            else if(indexPath.row ==1 )
            {       
                UITextField *savingField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:savingField];
                [savingField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"储值帐户", nil);
                [savingField setBackgroundColor:[UIColor whiteColor]];
                savingField.borderStyle = UITextBorderStyleRoundedRect;
                savingField.textAlignment = UITextAlignmentLeft;
                savingField.text = self.savings;
                savingField.tag = 1;
                savingField.delegate = self;
                savingField.keyboardType = UIKeyboardTypeNumberPad;
                [savingField addTarget:self action:@selector(saveSavingField:) forControlEvents:UIControlEventEditingChanged];
                
            }
            else if (indexPath.row == 2)
            {
                UITextField *pointField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:pointField];
                [pointField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"积分点数", nil);
                [pointField setBackgroundColor:[UIColor whiteColor]];
                pointField.borderStyle = UITextBorderStyleRoundedRect;
                pointField.textAlignment = UITextAlignmentLeft;
                pointField.text = self.point;
                pointField.tag = 1;
                pointField.delegate = self;
                pointField.keyboardType = UIKeyboardTypeNumberPad;
                [pointField addTarget:self action:@selector(savePointField:) forControlEvents:UIControlEventEditingChanged];
            }
            else if (indexPath.row == 3)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"隐私权限";
                if(self.privacyItem.count == 0){
                    cell.detailTextLabel.text= @"公开";
                }else {
                    NSMutableString *message = [[NSMutableString alloc]init];
                    NSArray *dealItemTitles = [NSArray arrayWithObjects:@"完全开放",@"基本信息开放",@"不开放", nil];
                    for(NSNumber *i in self.privacyItem){
                        [message appendFormat:@"%@,",[dealItemTitles objectAtIndex:i.intValue]];
                    }
                    cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
                }
            }
            else if (indexPath.row == 4)
            {
                cell.textLabel.text = @"到期时间";
                if([[self dateToString:self.dueTime] isEqualToString: [self dateToString:[NSDate date]]]){
                    cell.detailTextLabel.text = @"今天";
                }else {
                    cell.detailTextLabel.text = [self dateToString:self.dueTime];
                }    
            }
        }
    
   }else if(indexPath.section == 2){
        
            if (indexPath.row == 0)
            {
                UITextField *memPetNameFieldField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:memPetNameFieldField];
                [memPetNameFieldField setBackgroundColor:[UIColor whiteColor]];
                
                cell.textLabel.text = NSLocalizedString(@"会员昵称（商户）", nil);
                cell.detailTextLabel.text = @"必须填写";
                [memPetNameFieldField setBackgroundColor:[UIColor whiteColor]];
                memPetNameFieldField.borderStyle = UITextBorderStyleRoundedRect;
                memPetNameFieldField.textAlignment = UITextAlignmentLeft;
                memPetNameFieldField.text = self.memPetName;
                memPetNameFieldField.tag = 1;
                memPetNameFieldField.delegate = self;
                memPetNameFieldField.keyboardType = UIKeyboardTypeDefault;
                [memPetNameFieldField addTarget:self action:@selector(saveMemPetNameField:) forControlEvents:UIControlEventEditingChanged];
                

            }
           else if(indexPath.row ==1 )
            {        
                UITextField *savingField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:savingField];
                [savingField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"储值帐户", nil);
                [savingField setBackgroundColor:[UIColor whiteColor]];
                savingField.borderStyle = UITextBorderStyleRoundedRect;
                savingField.textAlignment = UITextAlignmentLeft;
                savingField.text = self.savings;
                savingField.tag = 1;
                savingField.delegate = self;
                savingField.keyboardType = UIKeyboardTypeNumberPad;
                [savingField addTarget:self action:@selector(saveSavingField:) forControlEvents:UIControlEventEditingChanged];
            }
            else if (indexPath.row == 2)
            {
                UITextField *pointField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
                [cell addSubview:pointField];
                [pointField setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.text = NSLocalizedString(@"积分点数", nil);
                [pointField setBackgroundColor:[UIColor whiteColor]];
                pointField.borderStyle = UITextBorderStyleRoundedRect;
                pointField.textAlignment = UITextAlignmentLeft;
                pointField.text = self.point;
                pointField.tag = 1;
                pointField.delegate = self;
                pointField.keyboardType = UIKeyboardTypeNumberPad;
                [pointField addTarget:self action:@selector(savePointField:) forControlEvents:UIControlEventEditingChanged];
        }
        else if (indexPath.row == 3)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"隐私权限";
            if(self.privacyItem.count == 0){
                cell.detailTextLabel.text= @"公开";
            }else {
                NSMutableString *message = [[NSMutableString alloc]init];
                NSArray *dealItemTitles = [NSArray arrayWithObjects:@"完全开放",@"基本信息开放",@"不开放", nil];
                for(NSNumber *i in self.privacyItem){
                    [message appendFormat:@"%@,",[dealItemTitles objectAtIndex:i.intValue]];
                }
                cell.detailTextLabel.text = [message substringToIndex:(message.length-1)];
            }
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"到期时间";
            if([[self dateToString:self.dueTime] isEqualToString: [self dateToString:[NSDate date]]]){
            cell.detailTextLabel.text = @"今天";
            }else {
            cell.detailTextLabel.text = [self dateToString:self.dueTime];
            }    
        }
    }    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    
    if (202 == self.status.intValue)
     {
        if(indexPath.section == 1 && indexPath.row ==2){
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
            exproposDateSelectedViewController *dateSelect = (exproposDateSelectedViewController *)controller;
            dateSelect.viewController = self;
            self.dateSel = @"birthTime";
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

    
       if (indexPath.section ==2 && indexPath.row == 4)
       {
           controller = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
           exproposDateSelectedViewController *dateSelect = (exproposDateSelectedViewController *)controller;
           dateSelect.viewController = self;
           self.dateSel = @"dueTime";
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
    
       if (indexPath.section ==2 && indexPath.row == 3)
       {
           exproposPrivacyController *privacyItemSelect = [[exproposPrivacyController alloc]init];
           privacyItemSelect.viewController = self;
           if (_popover == nil) {
               _popover = [[UIPopoverController alloc] initWithContentViewController:privacyItemSelect];
           }else {
               _popover.contentViewController = privacyItemSelect;
           }
           UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
           CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
           [_popover presentPopoverFromRect:popoverRect
                                  inView:cell //上面的矩形坐标是以这个view为参考的
                permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                                animated:YES];
         }
     }
     else
     {
         if (indexPath.section ==1 && indexPath.row == 4)
         {
             controller = [self.storyboard instantiateViewControllerWithIdentifier:@"dateSelect"];
             exproposDateSelectedViewController *dateSelect = (exproposDateSelectedViewController *)controller;
             dateSelect.viewController = self;
             self.dateSel = @"dueTime";
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
         
         if (indexPath.section ==1 && indexPath.row == 3)
         {
             exproposPrivacyController *privacyItemSelect = [[exproposPrivacyController alloc]init];
             privacyItemSelect.viewController = self;
             if (_popover == nil) {
                 _popover = [[UIPopoverController alloc] initWithContentViewController:privacyItemSelect];
             }else {
                 _popover.contentViewController = privacyItemSelect;
             }
             UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
             CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
             [_popover presentPopoverFromRect:popoverRect
                                       inView:cell //上面的矩形坐标是以这个view为参考的
                     permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                                     animated:YES];
         }
         
     }
}

-(void)showOrderNumPopover:(UITableViewCell *)cell {
   CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
    [_popover presentPopoverFromRect:popoverRect
                              inView:cell //上面的矩形坐标是以这个view为参考的
            permittedArrowDirections:UIPopoverArrowDirectionUp //箭头方向
                            animated:YES];
}



-(NSString *)dateToString:(NSDate *)date
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

-(void)nextAction:(UIButton *)sender
{
    self.telphone = self.telphone;
    self.validate = [[exproposValidater alloc]init];
    _validate.reserver = self;
    _validate.succeedCallBack = @selector(validateSuccess:);
    _validate.failedCallBack = @selector(validateFailer:);
    
    NSString *warning = nil;
    if (!self.telphone || ![self.telphone length]) {
        warning = NSLocalizedString(@"手机号码必须填写", nil);
    }
    
    else if ([self.telphone length] != 11 ) {
        warning = NSLocalizedString(@"手机号码输入有误", nil);
    }
    if (warning)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:warning 
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }    
    else {
        [_validate validate:self.telphone ];
    }
}

-(void)saveFromFirstNameField:(UITextField *)firstFieldText
{
    self.name = firstFieldText.text;
}
-(void)saveFromLastNameField:(UITextField *)lastFieldText
{
    self.petName = lastFieldText.text;
}

-(void)saveMemPetNameField:(UITextField *)memberPetFieldText
{
    self.memPetName = memberPetFieldText.text;
}

-(void)saveEmailField:(UITextField *)emailFieldText
{
    self.email = emailFieldText.text;
}
-(void)saveIdCardField:(UITextField *)idCardFieldText
{
    self.idCard = idCardFieldText.text;
}
-(void)saveCommentField:(UITextField *)commentFieldText
{
    self.comment = commentFieldText.text;
}

-(void)savePointField:(UITextField *)pointFieldText
{
    self.point = pointFieldText.text;
}
-(void)saveSavingField:(UITextField *)savingFieldText
{
    self.savings = savingFieldText.text;
}


-(void)saveFromTelField:(UITextField *)telText
{
    self.telphone = telText.text;
    
}

-(void)validateSuccess:(id)object
{
    NSDictionary *user = (NSDictionary *)object;
    NSLog(@"%@",user);
    NSLog(@"signin user:%@", [user objectForKey:@"status"]);    
    self.status = [user objectForKey:@"status"];
    if (405 == self.status.intValue)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:@"该用户已经是商户会员" 
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        NSFetchRequest *request = [ExproUser fetchRequest];
        NSPredicate *predicate = nil;
        NSMutableString *str = [[NSMutableString alloc]initWithString:@"(cellphone=%@)" ];
      
        NSMutableArray *userparams = [[NSMutableArray alloc]initWithObjects:self.telphone, nil];
        
        predicate = [NSPredicate predicateWithFormat:str argumentArray:userparams];
        
        NSLog(@"%@",predicate);
        
        request.predicate = predicate;
        NSArray *deals = [ExproUser objectsWithFetchRequest:request];
        ExproUser *user = nil;
        BOOL isExis=NO;
        if (deals.count)
        {
            user = (ExproUser *)[deals objectAtIndex:0];
            isExis=YES;
        }
        ExproMember *member = nil;
        NSArray *members = [ExproMember findAll];
        for(ExproMember *memberi in members){
            if(memberi.user.gid.intValue == user.gid.intValue){
                member = memberi;
            }
        }
        
        self.point = member.point.stringValue;
        self.savings = member.savings.stringValue;
        self.dueTime = member.dueTime;
        self.memPetName = member.petName;
        [self.privacyItem removeAllObjects];  
        [self.privacyItem addObject:member.privacy];
        [self.tableView reloadData];
    }
    else {
        self.point = @"";
        self.savings =@"";
        self.dueTime=[NSDate date];
        self.memPetName=@"";
        [self.privacyItem removeAllObjects];
        [self.tableView reloadData];
        self.createTime=[NSDate date];
        
        NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.mainViewController.menuTool.items mutableCopy]];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style: UIBarButtonItemStyleBordered   target:self action:@selector(registr:)];
        int num = 0;
        for(UIBarButtonItem *i in items){
            if([i.title isEqualToString:@"菜单"]){
                num = 1;
            }
        }
        [items insertObject:item atIndex:num];
        self.mainViewController.menuTool.items = items;
    }
    
}

-(void)validateFailer:(id)object
{
     NSLog(@"FAIL");
}


- (void)sexSelect:(UISegmentedControl *)sender {
   
    if (sender.isSelected)
    {
        self.sex = @"0";
    }
    else {
        self.sex = @"1";
    }
}

- (void)accountSelect:(UISegmentedControl *)sender {
    if (sender.isSelected)
    {
        self.account = sender.isSelected;
    }
    else {
    {
         self.account = sender.isSelected;
    }
}
}

@end
