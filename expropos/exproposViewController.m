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
#import "MyButton.h"


#import "exproposAppDelegate.h"
#import "exproposMainViewController.h"
@interface exproposViewController ()
@property (strong) exproposSign *sign;

@end

@implementation exproposViewController 

@synthesize orglabel;
@synthesize selUserButton=_selUserButton;
@synthesize passwordField = _passwordField;
@synthesize userField = _userField;
@synthesize exprodatabase=_exprodatabase;
@synthesize loginview=_loginview;

@synthesize usersView=_usersView;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory;
@synthesize waitting;
@synthesize users=_users;
@synthesize phonelable;
@synthesize userArray=_userArray;


@synthesize tapGesture;
@synthesize activeTextField;
@synthesize minMoveUpDeltaY;
@synthesize keyboardFrame;
@synthesize isSwitchedTextField;
@synthesize canUserSeeKeyboard;

- (IBAction)showLoginView:(id)sender {
    
    MyButton *bu = (MyButton *)sender;
    
    if (bu.tag == -1)
    {
        _userField.text = nil;
        self.userField.hidden= false;
        self.phonelable.hidden=false;
        self.orglabel.hidden=false;
       
     
    }
    else if(bu.tag == -2)
    {
        _userField.text = @"13770940001";
        
        self.userField.hidden= true;
        self.phonelable.hidden=true;
        self.orglabel.hidden=true;
    }
    else if (bu.tag = -3)
    {
        _userField.text = @"13770940002";
        self.userField.hidden= true;
        self.phonelable.hidden=true;
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
               
                self.userField.hidden= true;
                self.phonelable.hidden=true;
               
                self.orglabel.hidden=true;
                
            }
        }
    }
  
    [self.passwordField resignFirstResponder];

    int count = self.usersView.subviews.count;
    NSArray *buttonArray = self.usersView.subviews;
    for (int i = 0 ; i < count ; i++)
    {
        MyButton *button = [buttonArray objectAtIndex:i];
        
        [button removeFromSuperview];

    }
    
    [self loadMyButtonView:sender];
    
    //CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGRect rect = [self.loginview frame]; 
    rect.origin.x = (self.view.frame.size.height-rect.size.width)/2 ;  
    [self.loginview setFrame:rect]; 
    self.loginview.hidden=NO;
}
@synthesize sign = _sign;
- (IBAction)login:(id)sender {    
    password = _passwordField.text;
    username= _userField.text;
   
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setInteger:1 forKey:@"merchantID"];
    NSInteger orgIdint = [userDefault integerForKey:@"merchantID"];
    
        
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
         [self.waitting startAnimating];
        [self.sign signin:username password:password stroeId:[NSString stringWithFormat:@"%i",orgIdint]]; 
       
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    [userDefault setInteger:1 forKey:@"merchantID"];
    NSInteger orgIdint = [userDefault integerForKey:@"merchantID"];
    
    
    appDelegate.currentOrgid = [NSString stringWithFormat:@"%i",orgIdint];
    
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
    signHistory.orgId = appDelegate.currentOrgid;
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


-(void)loadMyView:(NSArray *)array
{
    self.usersView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.height-((array.count+3-1)*88+60))/2, 420,700,80)];    
    NSLog(@"%f",self.view.frame.size.width);
    int count = array.count > 5 ? 5: array.count;
    for (int i = 0 ; i < count ; i++)
    {
        ExproUser *user = [array objectAtIndex:i];
        
        if (user.signHistory)
        {  
            CGRect frame = CGRectMake(88*i, 5, 60, 80);
            
            MyButton *myButton =[[MyButton alloc]initWithFrame:frame];
            myButton.name = user.name;
            [myButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
            myButton.tag = user.gid.intValue;
            
            myButton.image = [UIImage imageNamed:@"dj_photo.png"];
            myButton.bgImage = [UIImage imageNamed:@"photoBg.png"];
                        
            
            
            [self.usersView addSubview:myButton];
        }        
    }  
    
    CGRect frame = CGRectMake(88*array.count, 5, 60, 80);
    MyButton *newButton =[[MyButton alloc]initWithFrame:frame];
    newButton.name = @"新用户";
    [newButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    newButton.tag = -1;
    newButton.image = [UIImage imageNamed:@"dj_photo.png"];
    newButton.bgImage = [UIImage imageNamed:@"photoBg.png"];
    [self.usersView addSubview:newButton];    
    
    CGRect syyframe = CGRectMake(88*(array.count+1), 5, 60, 80);
    MyButton *syyButton =[[MyButton alloc]initWithFrame:syyframe];
    syyButton.name = @"测试店长";
    [syyButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    syyButton.tag = -2;
    syyButton.image = [UIImage imageNamed:@"syy_photo.png"];
    syyButton.bgImage = [UIImage imageNamed:@"photoBg.png"];
    [self.usersView addSubview:syyButton];
    
    CGRect xgframe = CGRectMake(88*(array.count+2), 5,60, 80);
    MyButton *xgButton =[[MyButton alloc]initWithFrame:xgframe];
    xgButton.name = @"测试收银";
    [xgButton addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    xgButton.tag = -3;
    xgButton.image = [UIImage imageNamed:@"dz_photo.png"];
    xgButton.bgImage = [UIImage imageNamed:@"photoBg.png"];

    [self.usersView addSubview:xgButton];
    [_selUserButton removeFromSuperview ];
    [self.view addSubview:self.usersView];
}

-(void)loadMyButtonView:(id)sender
{
    CGRect frame = CGRectMake((self.view.frame.size.height-72)/2, 425, 60, 80);
    _selUserButton = (MyButton *)sender;
     _selUserButton.frame = frame;
    //[self.usersView addSubview:bu];
    [self.usersView removeFromSuperview];
    [self.view addSubview:_selUserButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userArray = [self loadSinginUser];
    NSMutableArray *delArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i =0; i < self.userArray.count ; i ++)
    {
        ExproUser *user = [self.userArray objectAtIndex:i];
        if ([user.cellphone isEqualToString:@"13770940001"] ||[user.cellphone isEqualToString:@"13770940002"])
        {
            [delArray addObject:user];
        }
    }
    [self.userArray removeObjectsInArray:delArray];
    
    [self loadMyView:self.userArray];
    
    self.loginview.hidden=true;
    //CGRect rect = [self.loginview frame]; 
    
    //rect.origin.x = 0.0f-rect.size.width;     
    //[self.loginview setFrame:rect];
    
    self.userField.delegate = self;
    
    self.userField.background = [UIImage imageNamed:@"inputBg.png"];
    self.passwordField.delegate = self;
    self.passwordField.background = [UIImage imageNamed:@"inputBg.png"];
    
    minMoveUpDeltaY = 0;
	keyboardFrame = CGRectZero;
	isSwitchedTextField = NO;
	canUserSeeKeyboard = NO;
	[self registerKeyboardNotifications];
   
    
}

-(IBAction)touchout:(id)sender
{   
    [self.passwordField resignFirstResponder];
   
    [self.userField resignFirstResponder];
    [self.passwordField setText:@""];
   
    [self.userField setText:@""];
    
    int count = self.usersView.subviews.count;
    NSArray *buttonArray = self.usersView.subviews;
    for (int i = 0 ; i < count ; i++)
    {
        MyButton *button = [buttonArray objectAtIndex:i];
        
        [button removeFromSuperview];
        
    }
    [self.loginview setHidden:YES];
    [self loadMyView:self.userArray];
    
}

- (void)viewDidUnload
{
    [self setPasswordField:nil];
    [self setUserField:nil];
    [self setPhonelable:nil];
   
    [self setOrglabel:nil];
    [self setWaitting:nil];
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

	minMoveUpDeltaY = 0;
	
	
    if (keyboardFrame.size.width < keyboardFrame.size.height) 
    {
        if (keyboardFrame.origin.x == 0)
        {
            minMoveUpDeltaY =  220 ;

        }
        else {
            minMoveUpDeltaY = 220;       
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
		self.view.frame = f;
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
    if (textField.text.length == 0)
    {
        int count = self.usersView.subviews.count;
        NSArray *buttonArray = self.usersView.subviews;
        for (int i = 0 ; i < count ; i++)
        {
            MyButton *button = [buttonArray objectAtIndex:i];
            
            [button removeFromSuperview];
            
        }
        [self.loginview setHidden:YES];
        [self loadMyView:self.userArray];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return  UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)didLoginSuccess:(NSString *)roleId
{
    [self.waitting stopAnimating];
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
-(NSMutableArray *)loadSinginUser
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
            
                if (exisUser.gid.intValue == user.gid.intValue)
                {
                    isExis = YES;
                }
            if ([user.cellphone isEqualToString:@"13770940001"])
            {
                isExis = YES;
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
