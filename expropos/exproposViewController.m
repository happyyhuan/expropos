//
//  exproposViewController.m
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposViewController.h"
#import "exproposSign.h"
#import "ExproRestDelegate.h"
#import "exproposAppDelegate.h"
#import "ExproUser.h"
#import "ExproMember.h"
#import "ExproSignHistory.h"
#import "JFBCrypt.h"
#import "ExproRole.h"


#import "exproposAppDelegate.h"
#import "exproposMainViewController.h"
@interface exproposViewController ()
@property (strong) exproposSign *sign;

@end

@implementation exproposViewController 
@synthesize orgField;
@synthesize orglabel;
@synthesize passwordField = _passwordField;
@synthesize userField = _userField;
@synthesize exprodatabase=_exprodatabase;
@synthesize loginview=_loginview;

@synthesize scrollview=_scrollview;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory;
@synthesize users=_users;
@synthesize phonelable;


@synthesize tapGesture;
@synthesize activeTextField;
@synthesize minMoveUpDeltaY;
@synthesize keyboardFrame;
@synthesize isSwitchedTextField;
@synthesize canUserSeeKeyboard;

- (IBAction)showLoginView:(id)sender {
    
    UIButton *bu = (UIButton *)sender;
    
    if (bu.tag == 0)
    {
        _userField.text = nil;
        self.userField.hidden= false;
        self.phonelable.hidden=false;
        self.orglabel.hidden=false;
        self.orgField.hidden=false;
        self.orgField.text=nil;
    }
    else if(bu.tag == -1)
    {
        _userField.text = @"12345678901";
        self.orgField.text = @"1";
        self.userField.hidden= true;
        self.phonelable.hidden=true;
        self.orgField.hidden=true;
        self.orglabel.hidden=true;
    }
    else {
        for (ExproUser *user in _users)
        {
            if (user.gid.intValue == bu.tag)
            {
                //查找是否存在user用户
                NSFetchRequest *request = [ExproSignHistory fetchRequest];
                NSPredicate *predicate = nil;
                NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
                NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:user.gid.stringValue, nil];
                
                predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
                
                NSLog(@"%@",predicate);
                
                request.predicate = predicate;
                NSArray *deals = [ExproUser objectsWithFetchRequest:request];
                ExproSignHistory *history = [deals objectAtIndex:0];
                
                
                _userField.text = user.cellphone;
                self.orgField.text = history.orgId;
                self.userField.hidden= true;
                self.phonelable.hidden=true;
                self.orgField.hidden=true;
                self.orglabel.hidden=true;
                
            }
        }
    }        
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    [UIView beginAnimations:@"Curl" context:context]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; 
    [UIView setAnimationDuration:0.5]; 
    CGRect rect = [self.loginview frame]; 
    rect.origin.x = (self.view.frame.size.height-rect.size.width)/2 ;  
    [self.loginview setFrame:rect]; 
    [UIView commitAnimations]; 
    self.loginview.hidden=false;
}
@synthesize sign = _sign;
- (IBAction)login:(id)sender {    
    password = _passwordField.text;
    username= _userField.text;
    orgId = self.orgField.text;
        
    if (username && [username length] && password && [password length]) {
        self.sign = [[exproposSign alloc]init];
        _sign.reserver = self;
        _sign.succeedCallBack = @selector(signinSucceed:);
        _sign.failedCallBack = @selector(signinFailed:);
        
        NSFetchRequest *request = [ExproUser fetchRequest];
        NSPredicate *predicate = nil;
        
        request.predicate = predicate;
        NSArray *deals = [ExproUser objectsWithFetchRequest:request];
        NSLog(@"%i",deals.count);
        [self.sign signin:username password:password stroeId:orgId]; 
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:NSLocalizedString(@"请输入用户名或密码", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

- (void) signinSucceed:(id)object {
    
    NSDictionary *user = (NSDictionary *)object;
    
    NSDictionary *role = (NSDictionary *)[user objectForKey:@"role"];
    
    NSLog(@"signin user:%@, roleId:%@", [user objectForKey:@"name"], [user objectForKey:@"role"]);   
    NSLog(@"signin roleid:%@", [role objectForKey:@"gid"]);   

    NSString *roleid = [role objectForKey:@"gid"]; 
     NSLog(@"signin roleid:%@", roleid);
        
    exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.currentOrgid = self.orgField.text;
    
    //登录成功后保存登录用户历史信息
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    //查找是否存在user用户
    NSFetchRequest *request = [ExproUser fetchRequest];
    NSPredicate *predicate = nil;
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"(cellphone=%@)" ];
    NSMutableArray *params = [[NSMutableArray alloc]initWithObjects:username, nil];
    
    predicate = [NSPredicate predicateWithFormat:str argumentArray:params];
    
    NSLog(@"%@",predicate);
    request.sortDescriptors = [[NSArray alloc]initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO], nil];
    request.predicate = predicate;
    NSArray *deals = [ExproUser objectsWithFetchRequest:request];
    ExproUser *signUser = nil;
    if (deals.count)
    {
        signUser = (ExproUser *)[deals objectAtIndex:0];
    }
    else 
    {
        signUser = [ExproUser object];
        signUser.cellphone = username;
        signUser.password=password;
        signUser.sex = [user objectForKey:@"sex"];
        signUser.name = [user objectForKey:@"name"];
        signUser.gid = [user objectForKey:@"gid"];
    }
    
    ExproSignHistory * signHistory = [ExproSignHistory object];
    signHistory.gid = [user objectForKey:@"gid"];
    NSDate *now = [NSDate date];
    signHistory.signintime = now;
    signHistory.user = signUser;
    signHistory.orgId = self.orgField.text;
    [manager.objectStore save:nil];
    
    appDelegate.currentUser = signUser;
    
    [appDelegate.sync syncStore:[NSNumber numberWithInt:15]];
    [self didLoginSuccess:roleid];
}

- (void) signinFailed:(id)object {
    
    if (self.sign.statusCode != 401)
    {
        //查找是否存在user用户
        NSFetchRequest *request = [ExproUser fetchRequest];
        NSPredicate *predicate = nil;
        NSMutableString *str = [[NSMutableString alloc]initWithString:@"(cellphone=%@)" ];
        NSMutableArray *userparams = [[NSMutableArray alloc]initWithObjects:self.userField.text, nil];
        predicate = [NSPredicate predicateWithFormat:str argumentArray:userparams];
        request.predicate = predicate;
        NSArray *deals = [ExproUser objectsWithFetchRequest:request];
        ExproUser *user = nil;
        BOOL isExis=NO;
        if (deals.count)
        {
            user = (ExproUser *)[deals objectAtIndex:0];
            isExis=YES;
        } 
        NSString *salt = [user.password substringToIndex:29];
        NSString *hashedPassword = [JFBCrypt hashPassword: password withSalt: salt];
        if ([user.password isEqualToString:hashedPassword])
        {
            [self signinSucceed:object];
            _userField.text = nil;
            _passwordField.text=nil;  
        }
        [self signinSucceed:object];
    }
    

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSArray *array = [self loadSinginUser];
    if (!array.count)
    {
        array = [self loadSinginUser];
    }
    
    UIView *scrollView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-(array.count*50))/2, 300,700,70)];    
    
    int count = array.count > 5 ? 5: array.count;
    for (int i = 0 ; i < count ; i++)
    {
        ExproUser *user = [array objectAtIndex:i];
        if (user.signHistory)
        {
            
            
            CGRect frame = CGRectMake(50*i, 5, 50, 40);
            
            UIButton *myButton =[UIButton buttonWithType:UIButtonTypeCustom];
            myButton.frame = frame;
            [myButton setBackgroundImage:[UIImage imageNamed:@"login_ico.png"] forState:UIControlStateNormal];
            [myButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
            myButton.tag = user.gid.intValue;
            
            CGRect labelframe = CGRectMake(10+50*i, 40, 50, 30);
            UILabel *mylabel = [UILabel new];
            mylabel.frame = labelframe;
            [mylabel setText:user.name];
            [mylabel setBackgroundColor:self.view.backgroundColor];
            [mylabel setFont:[UIFont systemFontOfSize:12]];
            [scrollView addSubview:myButton];
            [scrollView addSubview:mylabel];
        }        
    }  
    
    CGRect frame = CGRectMake(50*array.count, 5, 50, 40);
    UIButton *myButton =[UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = frame;
    [myButton setBackgroundImage:[UIImage imageNamed:@"login_ico.png"] forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    myButton.tag = 0;
    
    CGRect labelframe = CGRectMake(50*array.count+10, 40, 50, 30);
    UILabel *mylabel = [UILabel new];
    mylabel.frame = labelframe;
    [mylabel setText:@"新用户"];
    [mylabel setBackgroundColor:self.view.backgroundColor];
    [mylabel setFont:[UIFont systemFontOfSize:12]];
    [scrollView addSubview:myButton];
    [scrollView addSubview:mylabel];
    
    
    CGRect syyframe = CGRectMake(50*array.count+50, 5, 50, 40);
    UIButton *syyButton =[UIButton buttonWithType:UIButtonTypeCustom];
    syyButton.frame = syyframe;
    [syyButton setBackgroundImage:[UIImage imageNamed:@"login_ico.png"] forState:UIControlStateNormal];
    [syyButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    syyButton.tag = -1;
    
    CGRect syylabelframe = CGRectMake(50*array.count+10+50, 40, 50, 30);
    UILabel *syylabel = [UILabel new];
    syylabel.frame = syylabelframe;
    [syylabel setText:@"收银员"];
    [syylabel setBackgroundColor:self.view.backgroundColor];
    [syylabel setFont:[UIFont systemFontOfSize:12]];
    [scrollView addSubview:syyButton];
    [scrollView addSubview:syylabel];
    
    CGRect xgframe = CGRectMake(50*array.count+100, 5, 50, 40);
    UIButton *xgButton =[UIButton buttonWithType:UIButtonTypeCustom];
    xgButton.frame = xgframe;
    [xgButton setBackgroundImage:[UIImage imageNamed:@"login_ico.png"] forState:UIControlStateNormal];
    [xgButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    xgButton.tag = -2;    
    CGRect xglabelframe = CGRectMake(50*array.count+10+100, 40, 50, 30);
    UILabel *xglabel = [UILabel new];
    xglabel.frame = xglabelframe;
    [xglabel setText:@"管理员"];
    [xglabel setBackgroundColor:self.view.backgroundColor];
    [xglabel setFont:[UIFont systemFontOfSize:12]];
    [scrollView addSubview:xgButton];
    [scrollView addSubview:xglabel];
    
    
    [self.view addSubview:scrollView];
    self.loginview.hidden=true;
    CGRect rect = [self.loginview frame]; 
    
    rect.origin.x = 0.0f-rect.size.width;     
    [self.loginview setFrame:rect];
    
    self.userField.delegate = self;
    self.passwordField.delegate = self;
    self.orgField.delegate=self;
    
    minMoveUpDeltaY = 0;
	keyboardFrame = CGRectZero;
	isSwitchedTextField = NO;
	canUserSeeKeyboard = NO;
	[self registerKeyboardNotifications];
}

- (void)viewDidUnload
{
    [self setPasswordField:nil];
    [self setUserField:nil];
    [self setPhonelable:nil];
    [self setOrgField:nil];
    [self setOrglabel:nil];
    [super viewDidUnload];
    
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

- (void)handleTap {
	[activeTextField resignFirstResponder];
	isSwitchedTextField = NO;
}

- (void)handleKeyboardDidHide:(NSNotification *)notification {
	NSLog(@"\n----------------------------Did Hide----------------------------");
	canUserSeeKeyboard = NO;
    if (minMoveUpDeltaY != 0)
    {
        [self moveDown];
        minMoveUpDeltaY = 0;
        self.activeTextField = nil;
    }
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
    
//    if (canUserSeeKeyboard)
//    {
//        return NO;
//    }
//	if (minMoveUpDeltaY > 0) {
//		[self moveDown];
//	}
	minMoveUpDeltaY = 0;
	
	//exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//CGRect textFieldOriginFrameOnWindow = [self.view convertRect:self.loginview.frame toView:appDelegate.window];
    //	(UITextField在最初位置时的y) + (UITextField的height) - (键盘出现后的y) > 0
    if (keyboardFrame.size.width < keyboardFrame.size.height) 
    {
        if (keyboardFrame.origin.x == 0)
        {
            minMoveUpDeltaY =  300 ;

        }
        else {
            minMoveUpDeltaY = 300;       
        }
        
        
        if (minMoveUpDeltaY > 0) {
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
		[UIView setAnimationDuration:kKeyboardAnimationDuration];
		CGRect f = self.view.frame;
        if (keyboardFrame.size.width < keyboardFrame.size.height) 
        {
            if (keyboardFrame.origin.x == 0)
            {
                f.origin.x += minMoveUpDeltaY;
            }
            else
            {
                f.origin.x -= minMoveUpDeltaY;
            }
        }
		self.scrollview.frame = f;
		[UIView commitAnimations];
	}
}

- (void)moveDown {
	if (minMoveUpDeltaY > 0 ) {
		NSLog(@"minMoveUpDeltaY---->%f", minMoveUpDeltaY);
		[UIView beginAnimations:@"MoveDown" context:nil];
		[UIView setAnimationDuration:kKeyboardAnimationDuration];
		CGRect f = self.view.frame;
        if (keyboardFrame.size.width < keyboardFrame.size.height) 
        {
            if (keyboardFrame.origin.x == 0)
            {
                f.
                origin.x -= minMoveUpDeltaY;
            }
            else
            {
                f.origin.x += minMoveUpDeltaY;
            }
        }
		//f.origin.x -= minMoveUpDeltaY;
		self.view.frame = f;
		[UIView commitAnimations];
	}
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!canUserSeeKeyboard)
    {
        self.activeTextField = textField;// 设置当前活动的UITextF.y    
        if(  isSwitchedTextField == YES && [self isKeyboardHideTextField:activeTextField] == YES) {
            //[self moveUp];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (minMoveUpDeltaY != 0)
//    {
//        [self moveDown];
//        minMoveUpDeltaY = 0;
//        self.activeTextField = nil;
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation ==UIDeviceOrientationLandscapeLeft)||(interfaceOrientation ==UIDeviceOrientationLandscapeRight));
}

-(void)didLoginSuccess:(NSString *)roleId
{
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([roleId intValue] == 2)
    {
        UIViewController  *dealView = [self.storyboard instantiateViewControllerWithIdentifier:@"dealOperateVersion2"];
          appDelegate.window.rootViewController = dealView; 
         
    }
    else {
         UISplitViewController *splitView = [self.storyboard instantiateViewControllerWithIdentifier:@"splitView"];
         appDelegate.window.rootViewController = splitView;
    }    
}
-(NSArray *)loadSinginUser
{    
    //RKObjectManager *manager = [RKObjectManager sharedManager];
    
    //查找是否存在user用户
    NSFetchRequest *request = [ExproSignHistory fetchRequest];
    NSPredicate *predicate = nil;
        
    request.sortDescriptors = [[NSArray alloc]initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"signintime" ascending:NO], nil];
    
    request.predicate = predicate;
    NSArray *deals = [ExproSignHistory objectsWithFetchRequest:request];
    
    NSLog(@"%i",deals.count);
    
    NSMutableArray *userDeals = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i < deals.count ; i++)
    {
        ExproSignHistory *history = [deals objectAtIndex:i];
        ExproUser *user = history.user;
        
        BOOL isExis = NO;
        for (int j = 0 ; j < userDeals.count ; j++)
        {
            ExproUser *exisUser = [userDeals objectAtIndex:j];
            {
                if (exisUser.gid.intValue == user.gid.intValue)
                {
                    isExis = YES;
                }
            }
        }
        if (!isExis)
        {
            [userDeals addObject:user];
        }
    }
    self.users = userDeals;
    return userDeals;
}


@end
