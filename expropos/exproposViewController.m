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

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory;
@synthesize users=_users;
@synthesize phonelable;



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
    else {
        for (ExproUser *user in _users)
        {
            if (user.gid.intValue == bu.tag)
            {
                _userField.text = user.cellphone;
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
    rect.origin.x = (self.view.frame.size.width-rect.size.width)/2 ; 
    [self.loginview setFrame:rect]; 
    [UIView commitAnimations]; 
    self.loginview.hidden=false;
}
@synthesize sign = _sign;
- (IBAction)login:(id)sender {    
    password = _passwordField.text;
    username= _userField.text;
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
        
        [self.sign signin:username password:password];    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                        message:NSLocalizedString(@"UsernameAndPassword", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

- (void) signinSucceed:(id)object {
    
    NSDictionary *user = (NSDictionary *)object;
    NSLog(@"signin user:%@, sex:%@", [user objectForKey:@"name"], [user objectForKey:@"sex"]);   
    exproposAppDelegate *appDelegate = (exproposAppDelegate *)[[UIApplication sharedApplication]delegate];
    
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
    [manager.objectStore save:nil];
    
    appDelegate.currentUser = signUser;
    [appDelegate.sync syncStore:[NSNumber numberWithInt:15]];
    
    //    NSFetchRequest *request = [ExproSignHistory fetchRequest];
    //    NSPredicate *predicate = nil;
    //    
    //    request.predicate = predicate;
    //    NSArray *deals = [ExproSignHistory objectsWithFetchRequest:request];
    //    NSLog(@"%i",deals.count);
    //    
    //    for (ExproSignHistory *historys in deals)
    //    {
    //        NSLog(@"historys.gid%@",historys.gid);
    //         NSLog(@"historys.user.gid%@",historys.user.gid);
    //        NSLog(@"historys.user.cellphone%@",historys.user.cellphone);
    //        NSLog(@"historys.user.sex%@",historys.user.sex);
    //        NSLog(@"historys.user.name%@",historys.user.name);
    //    }
    
    
    
    [self didLoginSuccess];
}

- (void) signinFailed:(id)object {
    _userField.text = nil;
    _passwordField.text=nil;
    NSLog(@"statuscode == %i",self.sign.statusCode);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *array = [self loadSinginUser];
    if (!array.count)
    {
        array = [self loadSinginUser];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-(array.count*50))/2, 300,700,70)];    
    
    
    for (int i = 0 ; i < array.count ; i++)
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
    
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 70);
    scrollView.contentOffset = CGPointMake(0, 0);
    self.loginview.hidden=true;
    CGRect rect = [self.loginview frame]; 
    
    rect.origin.x = 0.0f-rect.size.width; 
    
    [self.loginview setFrame:rect];
}

- (void)viewDidUnload
{
    [self setPasswordField:nil];
    [self setUserField:nil];
    [self setPhonelable:nil];
    [self setOrgField:nil];
    [self setOrglabel:nil];
    [super viewDidUnload];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)didLoginSuccess
{
    
    
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UISplitViewController *splitView = [self.storyboard instantiateViewControllerWithIdentifier:@"splitView"];
    appDelegate.window.rootViewController = splitView;
    
}

//-(void)saveTestDate
//{
//    RKObjectManager *manager = [RKObjectManager sharedManager];
//        for(int i=0;i<5;i++){
//        ExproMember *m = [ExproMember object];
//        m.gid = [NSNumber numberWithInt:i];
//        m.petName = [NSString stringWithFormat:@"petName %i",i];
//        m.savings = [NSNumber numberWithInt:i];
//        m.point = [NSNumber numberWithInt:i];
//        ExproUser *user = [ExproUser object];
//        user.cellphone = [NSString stringWithFormat:@"1876182900%i",i];
//        user.name = @"陈纲";
//        user.gid = [NSNumber numberWithInt:i];
//        m.user= user;
//        
//        [manager.objectStore save:nil];
//    }
//}

-(NSArray *)loadSinginUser
{
    NSFetchRequest *request = [ExproUser fetchRequest];
    NSPredicate *predicate = nil;
    
    request.predicate = predicate;
    NSArray *deals = [ExproUser objectsWithFetchRequest:request];
    NSLog(@"%i",deals.count);
    self.users = deals;
    return deals;
    
}


- (void)keyboardWillShow:(NSNotification *)noti  
{          
    //键盘输入的界面调整          
    //键盘的高度  
    float height = 512.0;                  
    CGRect frame = self.view.frame;          
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);          
    [UIView beginAnimations:@"Curl"context:nil];//动画开始            
    [UIView setAnimationDuration:0.30];             
    [UIView setAnimationDelegate:self];            
    [self.view setFrame:frame];           
    [UIView commitAnimations];           
}  


- (BOOL)textFieldShouldReturn:(UITextField *)textField   
{          
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.          
    NSTimeInterval animationDuration = 0.30f;          
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];          
    [UIView setAnimationDuration:animationDuration];          
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);          
    self.view.frame = rect;          
    [UIView commitAnimations];          
    [textField resignFirstResponder];  
    return YES;          
}  

- (void)textFieldDidBeginEditing:(UITextField *)textField  
{          
    CGRect frame = textField.frame;  
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216  
    NSTimeInterval animationDuration = 0.30f;                  
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                  
    [UIView setAnimationDuration:animationDuration];  
    float width = self.view.frame.size.width;                  
    float height = self.view.frame.size.height;          
    if(offset > 0)  
    {  
        CGRect rect = CGRectMake(0.0f, -offset,width,height);                  
        self.view.frame = rect;          
    }          
    [UIView commitAnimations];                  
}  


@end
