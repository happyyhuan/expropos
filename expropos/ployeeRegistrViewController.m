//
//  exproposMemberRegisterController.m
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ployeeRegistrViewController.h"
#import "exproposDateSelectedViewController.h"
#import "exproposLeverSelectViewController.h"
#import "exproposAppDelegate.h"
#import "ployeeRegistr.h"
#import "exproposValidater.h"
#import "ExproMember.h"
#import "exproposRoleSelectViewController.h"
#import "ExproUser.h"
#import "ExproRole.h"
#import "ExproMerchant.h"
#import "ExproStore.h"
#import "storeSelectViewController.h"


@interface ployeeRegistrViewController ()
@property (strong) ployeeRegistr *ployeeregistr;
@property (strong) exproposValidater *validate;

@end


@implementation ployeeRegistrViewController

@synthesize mainViewController = _mainViewController;
@synthesize viewController = _viewController;

@synthesize name =_name;

@synthesize birth =_birth;
@synthesize petName= _petName;
@synthesize telphone =_telphone;
@synthesize registerButton = _registerButton;
@synthesize cancelButton = _cancelButton;
@synthesize levelItem=_levelItem;
@synthesize idCard =_idCard;
@synthesize email =_email;
@synthesize comment =_comment;
@synthesize popover = _popover;
@synthesize sex=_sex;
@synthesize account=_account;
@synthesize ployeeregistr =_ployeeregistr;
@synthesize validate=_validate;
@synthesize status=_status;
@synthesize tableView = _tableView;

@synthesize exproMember =_exproMember;
@synthesize memPetName=_memPetName;
@synthesize savings=_savings;
@synthesize createTime=_createTime;
@synthesize dueTime=_dueTime;
@synthesize privacyItem=_privacyItem;

@synthesize storeSelItem=_storeSelItem;
@synthesize point=_point;
@synthesize dateSel=_dateSel;
@synthesize nextButton;


@synthesize tapGesture;
@synthesize activeTextField;
@synthesize minMoveUpDeltaY;
@synthesize keyboardFrame;
@synthesize isSwitchedTextField;
@synthesize canUserSeeKeyboard;
BOOL isInfoModify = NO;



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
    if ([self exproMember])
    {
        isInfoModify = YES;
        [self.registerButton setTitle:@"修改" forState:UIControlStateNormal];
        self.telphone = self.exproMember.user.cellphone;
        self.point = self.exproMember.point.stringValue;
        self.savings = self.exproMember.savings.stringValue;
        self.dueTime = self.exproMember.dueTime;
        self.memPetName = self.exproMember.petName;
         _privacyItem = [[NSMutableArray alloc] initWithCapacity:20];
        [_privacyItem addObject:self.exproMember.roleID];
        
        //获取所在门店的index值
        _storeSelItem = [[NSMutableArray alloc] initWithCapacity:1];        
        NSArray *allStore = [ExproStore findAll];
        
        for(ExproStore * store in allStore) {
            for (ExproMember * staff in store.staffs) {
                
                if (staff.gid.intValue == self.exproMember.gid.intValue)
                {
                    NSLog(@"self.store.gid.==%i",store.gid.intValue);
                    NSArray *stores = [ExproStore findAll];
                    for (int i =0; i < stores.count ;i++)
                         {
                             ExproStore *storeSel = [stores objectAtIndex:i];
                             if (storeSel.gid.intValue ==  store.gid.intValue)
                             {
//                                 [self.storeSelItem addObject:[NSNumber numberWithInt:i]];
                                 NSLog(@"self.store.gid.==%@",store.name);
                                 [self.storeSelItem addObject:store.name];
                             }
                         }
                }
            }
        }
    }
    else {
        isInfoModify = NO;
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
        _storeSelItem = [[NSMutableArray alloc] initWithCapacity:20];     _dateSel = @"";
        _sex =@"0";
        _memPetName=@"";
        
    }
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    minMoveUpDeltaY = 0;
	keyboardFrame = CGRectZero;
	isSwitchedTextField = NO;
	canUserSeeKeyboard = NO;
	[self registerKeyboardNotifications];
}


- (void)viewDidUnload
{
    isInfoModify = NO;
    [self setRegisterButton:nil];
    [self setCancelButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    _telphone = nil;
    _name = nil;
    _petName = nil;
    _idCard =nil;
    _email = nil;
    _comment =nil;
    // Release any retained subviews of the main view.
    
	activeTextField = nil;
    [tapGesture removeTarget:self action:@selector(handleTap)];
	[self.view removeGestureRecognizer:tapGesture];
	tapGesture = nil;
    
}


#pragma mark - Custom Methods
- (void)registerKeyboardNotifications {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (IBAction)cancelAction:(id)sender {
    [self.viewController dismissModalViewControllerAnimated:YES];
}



- (IBAction)registerAction:(id)sender {
    if (!isInfoModify)
    {
        if (200 == self.status.intValue)
        {
            NSString *warning = nil;
            
            if (self.name.length == 0 ) {
                warning = NSLocalizedString(@"请输入姓名", nil);
            }
            if (self.memPetName.length == 0 ) {
                warning = NSLocalizedString(@"请输入商户会员昵称", nil);
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
                self.ployeeregistr = [[ployeeRegistr alloc]init];
                _ployeeregistr.reserver = self;
                _ployeeregistr.succeedCallBack = @selector(registrSucceed:);                                  
                NSArray *stores = [ExproStore findAll];
                NSNumber *storeSelId;
                for (int i =0; i < stores.count ;i++)
                { 
//                    NSNumber *index = [self.storeSelItem objectAtIndex:0];
//                    NSLog(@"index == %i",index.intValue);
//                    if (i ==  index.intValue)
//                    {
//                        ExproStore *storeSel = [stores objectAtIndex:i];
//                        NSLog(@"%i",storeSel.gid.intValue);
//                        storeSelId=storeSel.gid;
//                    }
                    NSString *selName = [self.storeSelItem objectAtIndex:0];
                    ExproStore *storeSel = [stores objectAtIndex:i];
                    NSString *storeName = storeSel.name;
                    if ([selName isEqualToString:storeName] )
                    {                          
                        storeSelId=storeSel.gid;
                    }
                    
                }     
                              
                [_ployeeregistr registr:self.telphone name:self.name petName:self.petName storeId:storeSelId.stringValue email:self.email
                           idCard:self.idCard comment:self.comment  sex:self.sex  
                                 saving:self.savings point:self.point dueTime:[self dateToString:self.dueTime] 
                            birth:[self dateToString:self.birth]
                       memPetName:self.memPetName role:self.privacyItem] ;
            }
        }
        else if (202 == self.status.intValue)//关联用户到商户
        {
            NSString *warning = nil;
            
            
            if (self.memPetName.length == 0 ) {
                warning = NSLocalizedString(@"请输入商户会员昵称", nil);
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
                self.ployeeregistr = [[ployeeRegistr alloc]init];
                _ployeeregistr.reserver = self;
                _ployeeregistr.succeedCallBack = @selector(registrSucceed:);
                
                NSArray *stores = [ExproStore findAll];
                NSNumber *storeSelId;
                for (int i =0; i < stores.count ;i++)
                { 
                    NSNumber *index = [self.storeSelItem objectAtIndex:0];
                    NSLog(@"index == %i",index.intValue);
                    if (i ==  index.intValue)
                    {
                        ExproStore *storeSel = [stores objectAtIndex:i];
                        NSLog(@"%i",storeSel.gid.intValue);
                        storeSelId=storeSel.gid;
                    }
                }       

                [_ployeeregistr registr:self.telphone name:self.name petName:self.petName storeId:storeSelId.stringValue email:self.email
                           idCard:self.idCard comment:self.comment  sex:self.sex  
                           saving:self.savings point:self.point dueTime:[self dateToString:self.dueTime]
                            birth:[self dateToString:self.birth]
                       memPetName:self.memPetName role:self.privacyItem];
            }
        }
    }
    else {  //保存修改的信息
        self.ployeeregistr = [[ployeeRegistr alloc]init];
        _ployeeregistr.reserver = self;
        _ployeeregistr.succeedCallBack = @selector(modifyStoreSucceed:);
        _ployeeregistr.failedCallBack = @selector(modifyStoreFailed:);
        
        NSArray *stores = [ExproStore findAll];
        NSNumber *storeSelId;
        for (int i =0; i < stores.count ;i++)
        { 
            NSNumber *index = [self.storeSelItem objectAtIndex:0];
            NSLog(@"index == %i",index.intValue);
            if (i ==  index.intValue)
            {
                ExproStore *storeSel = [stores objectAtIndex:i];
                NSLog(@"%i",storeSel.gid.intValue);
                storeSelId=storeSel.gid;
            }
        }       
        [_ployeeregistr modify:self.exproMember.gid.stringValue  cellPhone:self.telphone storeId:storeSelId.stringValue  
                       petName:self.petName email:self.email
                  idCard:self.idCard comment:self.comment  sex:self.sex  
                  saving:self.savings point:self.point dueTime:self.dueTime
                   birth:[self dateToString:self.birth]
              memPetName:self.memPetName role:self.privacyItem];   
                //[self.viewController dismissModalViewControllerAnimated:YES];
    }
}



- (void)handleTap {
	[activeTextField resignFirstResponder];
	isSwitchedTextField = NO;
}

- (void)handleKeyboardDidHide:(NSNotification *)notification {
	NSLog(@"\n----------------------------Did Hide----------------------------");
	canUserSeeKeyboard = NO;
}

- (void)handleKeyboardDidShow:(NSNotification *)notification {
	NSLog(@"\n----------------------------Did Show----------------------------");
	canUserSeeKeyboard = YES;
	
	// 设置键盘出现时的矩形框
	[self setKeyboardFrameByNSNotification:notification];
}

- (void)setKeyboardFrameByNSNotification:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSValue *keyboardFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardEndFrame = [keyboardFrameEndValue CGRectValue];
	NSLog(@"End Frame = %@", NSStringFromCGRect(keyboardEndFrame));
	
	keyboardFrame = keyboardEndFrame;
    
	BOOL isHiden = [self isKeyboardHideTextField:self.activeTextField];
	if (isHiden == YES) {
		isSwitchedTextField = YES;
		[self moveUp];
	}
}

- (BOOL)isKeyboardHideTextField:(UITextField *)textField {
	/* 
	 切换输入框或iOS 5的中英键盘时，先让整个视图回到原始位置，
	 然后再考虑是否需要上移，如果需要上移，那么动画会出现闪烁效果，感觉不是太好。
	 */
	if (minMoveUpDeltaY > 0) {
		[self moveDown];
	}
	minMoveUpDeltaY = 0;
	
	exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	CGRect textFieldOriginFrameOnWindow = [self.view convertRect:self.activeTextField.superview.frame toView:appDelegate.window];
    //	(UITextField在最初位置时的y) + (UITextField的height) - (键盘出现后的y) > 0
    if (keyboardFrame.size.width < keyboardFrame.size.height) 
    {
        if (keyboardFrame.origin.x == 0)
        {
            minMoveUpDeltaY = keyboardFrame.size.width - textFieldOriginFrameOnWindow.origin.x;
        }
        else {
            minMoveUpDeltaY =  textFieldOriginFrameOnWindow.origin.x - keyboardFrame.origin.x + 44;
        }
        
        NSLog(@"重新计算之后minMoveUpDeltaY = %f", minMoveUpDeltaY);
        if (minMoveUpDeltaY > 0) {
            // minMoveUpDeltaY = keyboardFrame.origin.x - 44;
            return YES;
        }
    }
    else {
        return NO;
    }
    
    
	return NO;
}

- (void)moveUp {
	if (minMoveUpDeltaY > 0) {
		NSLog(@"moveUp---->%f", minMoveUpDeltaY);
		[UIView beginAnimations:@"MoveUp" context:nil];
		[UIView setAnimationDuration:keyboardAnimationDuration];
		CGRect f = self.view.frame;
		f.origin.y -= minMoveUpDeltaY;
		self.view.frame = f;
		[UIView commitAnimations];
	}
}

- (void)moveDown {
	if (minMoveUpDeltaY > 0) {
		NSLog(@"minMoveUpDeltaY---->%f", minMoveUpDeltaY);
		[UIView beginAnimations:@"MoveDown" context:nil];
		[UIView setAnimationDuration:keyboardAnimationDuration];
		CGRect f = self.view.frame;
		f.origin.y += minMoveUpDeltaY;
		self.view.frame = f;
		[UIView commitAnimations];
	}
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.activeTextField = textField;// 设置当前活动的UITextF.y    
	if (isSwitchedTextField == YES && [self isKeyboardHideTextField:activeTextField] == YES) {
		[self moveUp];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self moveDown];
	minMoveUpDeltaY = 0;
	self.activeTextField = nil;
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (200 == self.status.intValue )
    {
        return  3 ;
    }
    else if (202 == self.status.intValue || 406 == self.status.intValue || isInfoModify){
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (200 == self.status.intValue)
    {
        if(section == 0){
            return 1;
        }
        if(section == 1){
            return 7;
        }
        return 3;
    }
    else {
        if(section == 0){
            return 1;
        }
        else {
            return 3;
        }
    }
    
    return 0;       
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        
        UITextField *telField = [[UITextField alloc]initWithFrame:CGRectMake(300, 10, 200, 25)];
        [cell addSubview:telField];
        
        [telField setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.text = NSLocalizedString(@"手机", nil);  
        
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
        if (200 == self.status.intValue)
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
                [firstFieldField addTarget:self action:@selector(saveFromFirstNameField:) forControlEvents:UIControlEventEditingDidEnd];
                
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
           else if (indexPath.row == 1)
            {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"职务";
                NSArray *roles = [ExproRole findAll];
                NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
                
                for (int i =0;i<roles.count;i++)
                {
                    ExproRole *role = [roles objectAtIndex:i];                
                    [names addObject:role.name];
                }
                if(self.privacyItem.count == 0){
                    cell.detailTextLabel.text= @"请选择";
                }
                else {      
                    for (int i =0;i<roles.count;i++)
                    {
                        NSString *index = [self.privacyItem objectAtIndex:0];
                        if (i ==  index.intValue)
                        {
                            cell.detailTextLabel.text = [names objectAtIndex:i];
                        }           
                    }           
                }                
                
            }
           
            else if (indexPath.row == 2)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"所属门店";

                //查找该商户的所有门店信息
                exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSString *orgId = appDelegate.currentOrgid ;
                NSFetchRequest *request = [ExproMerchant fetchRequest];
                NSPredicate *predicate = nil;
                NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
                NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:orgId, nil];
                predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
                NSLog(@"%@",predicate);
                request.predicate = predicate;
                NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
                NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
                for (int i =0;i<merchants.count;i++)
                {
                    ExproMerchant *merchant = [merchants objectAtIndex:i];  
                    NSSet *stores = merchant.stores;
                    for(ExproStore *item in stores){
                        [names addObject:item.name]; 
                    }
                }
                               
                if(self.storeSelItem.count == 0){
                    cell.detailTextLabel.text= @"请选择";
                }
                else
                {      
                    for (int i =0;i<names.count;i++)
                    {     
                        NSString *selName = [self.storeSelItem objectAtIndex:0];
                        NSString *name = [names objectAtIndex:i];
                        if ([selName isEqualToString: name])
                        {
                            cell.detailTextLabel.text = selName;
                        }           
                    }            
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
        else if (indexPath.row == 1)
        {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"职务";
            NSArray *roles = [ExproRole findAll];
            NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
            
            for (int i =0;i<roles.count;i++)
            {
                ExproRole *role = [roles objectAtIndex:i];                
                [names addObject:role.name];
            }
            if(self.privacyItem.count == 0){
                cell.detailTextLabel.text= @"请选择";
            }
            else {      
                for (int i =0;i<roles.count;i++)
                {
                    ExproRole *role = [roles objectAtIndex:i];  
                    
                    NSString *index = [self.privacyItem objectAtIndex:0];
                    if (i ==  index.intValue)
                    {
                        cell.detailTextLabel.text = role.name;
                    }           
                }           
            }

            
        }
        else if(indexPath.row ==2 )
        {        
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"所属门店";
            
            //查找该商户的所有门店信息
            exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
            NSString *orgId = appDelegate.currentOrgid ;
            NSFetchRequest *request = [ExproMerchant fetchRequest];
            NSPredicate *predicate = nil;
            NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
            NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:orgId, nil];
            predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
            NSLog(@"%@",predicate);
            request.predicate = predicate;
            NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
            NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i =0;i<merchants.count;i++)
            {
                ExproMerchant *merchant = [merchants objectAtIndex:i];  
                NSSet *stores = merchant.stores;
                for(ExproStore *item in stores){
                    [names addObject:item.name]; 
                }
            }
            if(self.storeSelItem.count == 0){
                cell.detailTextLabel.text= @"请选择";
            }
            else {      
                for (int i =0;i<names.count;i++)
                {   
                    NSString *index = [self.storeSelItem objectAtIndex:0];
                    if (i ==  index.intValue)
                        
                    {
                        cell.detailTextLabel.text = [names objectAtIndex:i];
                    }           
                }              
            }                

        }
    }    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    
    if (200 == self.status.intValue)
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
        
        if (indexPath.section ==2 && indexPath.row == 2)
        {
            storeSelectViewController *storeItemSelect = [[storeSelectViewController alloc]init];
            storeItemSelect.viewController = self;
            if (_popover == nil) {
                _popover = [[UIPopoverController alloc] initWithContentViewController:storeItemSelect];
            }else {
                _popover.contentViewController = storeItemSelect;
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
            [_popover presentPopoverFromRect:popoverRect
                                      inView:cell //上面的矩形坐标是以这个view为参考的
                    permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                                    animated:YES];
        }
        
        if (indexPath.section ==2 && indexPath.row == 1)
        {
            exproposRoleSelectViewController *roleItemSelect = [[exproposRoleSelectViewController alloc]init];
            roleItemSelect.viewController = self;
            if (_popover == nil) {
                _popover = [[UIPopoverController alloc] initWithContentViewController:roleItemSelect];
            }else {
                _popover.contentViewController = roleItemSelect;
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
        if (indexPath.section ==1 && indexPath.row == 1)
        {
            exproposRoleSelectViewController *roleItemSelect = [[exproposRoleSelectViewController alloc]init];
            
                        roleItemSelect.viewController = self;
            if (_popover == nil) {
                _popover = [[UIPopoverController alloc] initWithContentViewController:roleItemSelect];
            }else {
                _popover.contentViewController = roleItemSelect;
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect popoverRect = CGRectMake(cell.bounds.origin.x + cell.bounds.size.width - 100, cell.bounds.origin.y,27, 32);
            [_popover presentPopoverFromRect:popoverRect
                                      inView:cell //上面的矩形坐标是以这个view为参考的
                    permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
                                    animated:YES];
        }
        else if (indexPath.section ==1 && indexPath.row == 2)
        {
                storeSelectViewController *storeItemSelect = [[storeSelectViewController alloc]init];
                storeItemSelect.viewController = self;
                if (_popover == nil) {
                    _popover = [[UIPopoverController alloc] initWithContentViewController:storeItemSelect];
                }else {
                    _popover.contentViewController = storeItemSelect;
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
            permittedArrowDirections:UIPopoverArrowDirectionRight //箭头方向
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



-(void)nextAction
{
    self.validate = [[exproposValidater alloc]init];
    _validate.registerController = self;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    if (telText.text.length > 11)
    {
        NSString *warning = nil;
        
        warning = NSLocalizedString(@"手机号码输入有误", nil);
        
        if (warning)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                            message:warning 
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    if (telText.text.length == 11)
    {
        if (![self.telphone isEqualToString:telText.text])
        {
            [self.tableView reloadData];
        }
        self.telphone = telText.text;
        [self nextAction];
    }
    self.telphone = telText.text;
    
}

-(void)validateSuccess:(id)object
{
    NSLog(@"self.status == %@",self.status);
    
    self.point = @"";
    self.savings =@"";
    self.dueTime=[NSDate date];
    self.memPetName=@"";
    [self.privacyItem removeAllObjects];
    [self.storeSelItem removeAllObjects];
    [self.tableView reloadData];
    self.createTime=[NSDate date];
    
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:[self.mainViewController.menuTool.items mutableCopy]];
    
    
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(UIBarButtonItem *item in items){
        if([item.title isEqualToString:@"注册"]){
            [removeItems addObject: item]; 
        }   
    }
    [items removeObjectsInArray:removeItems];
    
    
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

-(void)validateFailer:(id)object
{
    NSLog(@"self.status == %@",self.status);
    if (406 == self.status.intValue)
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
        [self.privacyItem addObject:member.roleID];
        
        [self.storeSelItem removeAllObjects];
        ExproStore *allStore = [ExproStore findAll];
        
        for(ExproStore * store in allStore) {
            for (ExproMember * staff in store.staffs) {
                if (staff.gid == member.gid)
                {
                    [self.storeSelItem addObject:store.gid];
                }
            }

        }
                
        [self.tableView reloadData];
        
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
}


- (void) modifyStoreSucceed:(id)object {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:@"用户信息修改成功" 
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    
    [alert show]; 
    //关闭对话框
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (void) modifyStoreFailed:(id)object {
    
    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
    //                                                    message:@"用户信息修改成功" 
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
    //                                          otherButtonTitles:nil];
    //    
    //    [alert show]; 
    
}


- (void) registrSucceed:(id)object {
    
    if (!isInfoModify)
    {
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
        self.storeSelItem=nil;
        self.memPetName = nil;
        [self.tableView reloadData];
        
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:@"用户信息修改成功" 
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        
        [alert show]; 
    }
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
