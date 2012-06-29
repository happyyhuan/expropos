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


#import "exproposAppDelegate.h"
#import "exproposMainViewController.h"
@interface exproposViewController ()
@property (strong) exproposSign *sign;

@end

@implementation exproposViewController 
@synthesize passwordField = _passwordField;
@synthesize userField = _userField;
@synthesize exprodatabase=_exprodatabase;
@synthesize loginview=_loginview;

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory;



- (IBAction)showLoginView:(id)sender {
    if(!self.loginview.hidden)
    {
        self.loginview.hidden = true;  
    }
    else {
        self.loginview.hidden = false;
    }
}
@synthesize sign = _sign;
- (IBAction)login:(id)sender {    
    username = _userField.text;
    password = _passwordField.text;
    if (username && [username length] && password && [password length]) {
        self.sign = [[exproposSign alloc]init];
        _sign.reserver = self;
        _sign.succeedCallBack = @selector(signinSucceed:);
        _sign.failedCallBack = @selector(signinFailed:);
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
    appDelegate.userName = [user objectForKey:@"name"];
    NSLog(@"appDelegatename:%@",appDelegate.userName);
    appDelegate.gid =[user objectForKey:@"gid"];
    NSLog(@"appDelegategid:%@",appDelegate.gid);
    [self performSegueWithIdentifier:@"successed" sender:self];
    
    
    
//    ExproUser *person=(ExproUser *)[NSEntityDescription insertNewObjectForEntityForName:@"ExproUser" inManagedObjectContext:[self managedObjectContext]]; 
//    person.name=@"张三";
//    
//    NSError *error;
//    
//    if (![[self managedObjectContext] save:&error]) { 
//        NSLog(@"error!"); 
//    }else { 
//        NSLog(@"save person ok."); 
//    }
//    
//    NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
//    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]; 
//    [request setEntity:entity];
//    
//    NSArray *results=[[[self managedObjectContext] executeFetchRequest:request error:&error] copy];
    
//    for (ExproUser *p in results) { 
//        NSLog(@">> p.id: %i p.name: %@",p.gid,p.name); 
//    }
    
    
    
    
}

- (void) signinFailed:(id)object {
    _userField.text = nil;
    _passwordField.text=nil;
//    ExproUser *person=(ExproUser *)[NSEntityDescription insertNewObjectForEntityForName:@"ExproUser" inManagedObjectContext:self.managedObjectContext]; 
//    person.name=@"张三";
//    
//    NSError *error;
//    
//    if (![[self managedObjectContext] save:&error]) { 
//        NSLog(@"error!"); 
//    }else { 
//        NSLog(@"save person ok."); 
//    }
//    
//    NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
//    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ExproUser" inManagedObjectContext:[self managedObjectContext]]; 
//    [request setEntity:entity];
//    
//    NSArray *results=[[[self managedObjectContext] executeFetchRequest:request error:&error] copy];
//    
//    for (ExproUser *p in results) { 
//        NSLog(@">> p.id: %i p.name: %@",p.gid,p.name); 
//    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginview.hidden = true;  
}

- (void)viewDidUnload
{
    [self setPasswordField:nil];
    [self setUserField:nil];
    [super viewDidUnload];}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([@"showSplit" isEqualToString:segue.identifier]){
        
        exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UISplitViewController *splitView = [self.storyboard instantiateViewControllerWithIdentifier:@"splitView"];
        appDelegate.window.rootViewController = splitView;
        
    }
}

@end
