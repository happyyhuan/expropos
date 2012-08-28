//
//  exproposPloyeeManagerViewController.m
//  expropos
//
//  Created by chen on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposPloyeeManagerViewController.h"
#import "ExproMember.h"
#import "RestKit/RestKit.h"
#import "RestKit/CoreData.h"
#import "expropoStoreEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ployeeRegistrViewController.h"
#import "exproposAppDelegate.h"
#import "ExproRole.h"
#import "ExproStaff.h"

@interface exproposPloyeeManagerViewController ()

@end

@implementation exproposPloyeeManagerViewController
@synthesize ployTableView = _ployTableView;
@synthesize searchBar;
@synthesize backButton;
@synthesize registButton;
@synthesize modifyButton;
@synthesize delButton;
@synthesize telphone;
@synthesize name;
@synthesize idCard;
@synthesize storeName;
@synthesize roleName;
@synthesize ployeeItems=_ployeeItems;
@synthesize allPloyee=_allPloyee;
@synthesize myRootViewController = _myRootViewController;
@synthesize currentPloyeeId=_currentPloyeeId;

int currentPloyee = 0;
int selectedPloyee =0;

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
   
    _allPloyee = [[NSMutableArray alloc]initWithCapacity:1];
    
    
    
    //获取该商户下所有会员
   NSArray *allMemebers = [NSMutableArray arrayWithArray:[ExproMember findAll]];
//     NSMutableArray *members = [NSMutableArray arrayWithArray:[ExproMember findAll]];
//    exproposAppDelegate *appDelegate =[[UIApplication sharedApplication]delegate];
//    NSString *orgId = appDelegate.currentOrgid ;
     NSArray *allStore = [ExproStore findAll];
    
//    for (int i = 0 ; i < allMemebers.count;i++)
//    {
//        ExproMember *mem = [allMemebers objectAtIndex:i];
//       
//        if ([mem.orgID.stringValue isEqualToString:orgId])
//        {
//            [members addObject:mem];
//        }
//    }
//    
//    NSArray *allStore = [ExproStore findAll];
//   
//    for(ExproStore * store in allStore) {
//        
//        for (ExproMember *staff in store.staffs)
//        {
//            for (int i = 0 ; i < members.count;i++)
//            {
//                ExproMember *member = [members objectAtIndex:i];
//                
//                if (member.gid.intValue == staff.gid.intValue)
//                {
//                    ///[_allPloyee addObject:member];
//
//                }
//            }
//        }
//    }
    
    
    for(ExproStore * store in allStore) {
        for (ExproMember * staff in store.staffs) {
            
            for (int i=0; i<allMemebers.count;i++)
            {
                ExproMember *m = [allMemebers objectAtIndex:i];                                 
            if (staff.gid.intValue == m.gid.intValue)
            {
                NSLog(@"self.store.gid.==%i",store.gid.intValue);
                                    [_allPloyee addObject:m]; 
            }
            }
        }
    }
    
    

    
    
    
    NSLog(@"会员信息从ployeeManager获取 == %i",_allPloyee.count);
//    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:1];
//    _ployeeItems = [[NSMutableArray alloc]initWithCapacity:1];
//    for (int i=0; i < self.allPloyee.count;i++)
//    {
//        ExproMember *member = [self.allPloyee objectAtIndex:i];
//        if (!member.petName)
//        {
//            [deletes addObject:member];
//        }
//    }    
//    [self.allPloyee removeObjectsInArray:deletes];    
//    _ployeeItems = [[NSMutableArray alloc]initWithCapacity:1];  
//    for (int i=0 ; i < 6;i++)
//    {
//        if (i < self.allPloyee.count)
//        {
//            [self.ployeeItems addObject: [_allPloyee objectAtIndex:i]];
//            currentPloyee = 6;      
//        }
//        else {
//            currentPloyee = self.allPloyee.count;
//        }
//    }
    if(self.allPloyee.count !=0)
    {
        //---初始化时候显示默认第一条数据的信息
        ExproMember *member = [self.allPloyee objectAtIndex:0];
        
        [self.telphone setText: member.user.cellphone];
        [self.name setText:member.user.name];
        [self.idCard setText:member.user.idcard];
        
        NSArray *roles = [ExproRole findAll];
        
        for (int i =0;i<roles.count;i++)
        {
            
            ExproRole *role = [roles objectAtIndex:i];    
            if (member.role.gid.intValue == role.gid.intValue)
            {
                [self.roleName setText:role.name];
            }
        }
       
        //获取所在门店的名称
        
        NSArray *allStore = [ExproStore findAll];
        
        for(ExproStore * store in allStore) {
            for (ExproMember * staff in store.staffs) {
                
                if (staff.gid.intValue == member.gid.intValue)
                {
                    NSLog(@"self.store.gid.==%i",store.gid.intValue);
                    for (int i =0; i < allStore.count ;i++)
                    {
                        ExproStore *storeSel = [allStore objectAtIndex:i];
                        [self.storeName setText: storeSel.name];
                    }
                }
            }
        }      
        //----end
        
    }
     self.searchBar.delegate = self;
    _ployTableView.bounces = NO;
    _ployTableView.showsVerticalScrollIndicator = YES;  
    _ployTableView.layer.cornerRadius = 5.0;
    _ployTableView.layer.masksToBounds = YES;
    _ployTableView.layer.borderWidth = 3;
    _ployTableView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)viewDidUnload
{
    [self setPloyTableView:nil];
    [self setSearchBar:nil];
    [self setBackButton:nil];
    [self setRegistButton:nil];
    [self setModifyButton:nil];
    [self setDelButton:nil];
    [self setTelphone:nil];
    [self setName:nil];
    [self setIdCard:nil];
    [self setStoreName:nil];
    [self setRoleName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    int count = [self.ployeeItems count];
//    if (count < [self.allPloyee count])
//    {
//        return count+1;  
//    }
//    else
//    {
//        return count;
//    }
    return self.allPloyee.count;
}

//-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100.0;
//}

#pragma mark -

-(void)searchWithNameOrId:(NSString *)nameOrId
{
    currentPloyee = 0 ;
    _allPloyee = [NSMutableArray arrayWithArray:[ExproMember findAll]];
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:1];
    //_ployeeItems = [[NSMutableArray alloc]initWithCapacity:1];
    if (nameOrId.length != 0)
    {
        for (int i=0; i < self.allPloyee.count;i++)
        {
            ExproMember *member = [self.allPloyee objectAtIndex:i];
            if([member.petName rangeOfString:nameOrId ].location == NSNotFound)
            {
                [deletes addObject:member];
            }
            if (!member.petName)
            {
                [deletes addObject:member];
            }
        }
    }
    
    [self.allPloyee removeObjectsInArray:deletes];
//    for (int i=0 ; i < 6;i++)
//    {
//        if (i < _allPloyee.count)
//        {
//            [self.ployeeItems addObject: [_allPloyee objectAtIndex:i]];
//            currentPloyee = 6;      
//        }
//        else {
//            currentPloyee = _allPloyee.count;
//        }
//    }
    
    [self.ployTableView reloadData];
}

- (void)scrollToTop:(BOOL)animated {  
    [self.ployTableView setContentOffset:CGPointMake(0,0) animated:animated];  
}  

- (void)scrollToBottom:(BOOL)animated {  
    NSUInteger sectionCount = [self.ployTableView numberOfSections];  
    if (sectionCount) {  
        NSUInteger rowCount = [self.ployTableView numberOfRowsInSection:0];  
        if (rowCount) {  
            NSUInteger ii[2] = {0, rowCount-1};  
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];  
            [self.ployTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  
                                                animated:animated];  
        }  
    }  
}  

#pragma mark -
#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithNameOrId:searchText];    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.ployTableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    if([indexPath row] == ([self.ployeeItems count])) { 
//        //创建loadMoreCell 
//        if ([indexPath row] > 5)
//        {
//            CGRect frame = cell.bounds;
//            frame.size.height = 40;
//            cell.frame = frame;
//            
//            
//            UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 304, 50)];
//            [myLable setText:@"查看更多..."];
//            myLable.backgroundColor = [UIColor clearColor ];
//            myLable.textColor = [UIColor blackColor];
//            
//            myLable.font = [UIFont systemFontOfSize: 15];
//            
//            myLable.textAlignment = UITextAlignmentCenter;
//            
//            myLable.layer.cornerRadius = 5.0;
//            myLable.layer.masksToBounds = YES;
//            myLable.layer.borderWidth = 3;
//            myLable.layer.borderColor = [[UIColor grayColor] CGColor];
//            myLable.tag = indexPath.row;
//            myLable.backgroundColor = [ UIColor clearColor];
//            
//            [cell addSubview:myLable]; 
//        }
//    }else { 
//        CGRect frame = cell.bounds;
//        frame.size.height = 100;
//        frame.size.width = frame.size.width-80;
//        frame.origin.x = frame.origin.x + 80;
//        UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
//        [myLable setText:[NSString stringWithFormat:@"%i",indexPath.row]];
//        myLable.backgroundColor = [UIColor clearColor ];
//        myLable.textColor = [UIColor redColor];
//        
//        myLable.font = [UIFont systemFontOfSize: 15];
//        
//        myLable.textAlignment = UITextAlignmentCenter;
//        
//        myLable.layer.cornerRadius = 5.0;
//        myLable.layer.masksToBounds = YES;
//        myLable.layer.borderWidth = 3;
//        myLable.layer.borderColor = [[UIColor grayColor] CGColor];
//        myLable.tag = indexPath.row;
//        
//        UIButton *myButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        myButton.frame = frame;
//        ExproMember *member = [self.ployeeItems objectAtIndex:indexPath.row];
//        myButton.titleLabel.text =member.petName;
//        
//        if (selectedPloyee == indexPath.row)
//        {
//            myButton.backgroundColor = [UIColor yellowColor];
//            myLable.backgroundColor = [UIColor yellowColor];
//        }
//        else {
//            myButton.backgroundColor = [UIColor grayColor];
//            myLable.backgroundColor = [UIColor grayColor];
//        }
//        
//        [myButton setTitle:member.petName forState:UIControlStateNormal];
//        
//        [myButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
//        myButton.tag = indexPath.row;
//        myButton.layer.cornerRadius = 5.0;
//        myButton.layer.masksToBounds = YES;
//        myButton.layer.borderWidth = 3;
//        myButton.layer.borderColor = [[UIColor grayColor] CGColor];        
//        [cell addSubview:myButton];
//        [cell addSubview:myLable];
//    } 
    
    ExproMember *member = [self.allPloyee objectAtIndex:indexPath.row];
    cell.textLabel.text = member.petName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if([indexPath row] == ([self.ployeeItems count])) { 
//        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath]; 
//        loadMoreCell.textLabel.text=@"loading more …"; 
//        [self performSelectorInBackground:@selector(loadMore) withObject:nil]; 
//        [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
//        return; 
//    } 
    _currentPloyeeId = indexPath.row;
    ExproMember *member = [self.allPloyee objectAtIndex:_currentPloyeeId];
    
    [self.telphone setText: member.user.cellphone];
    [self.name setText:member.user.name];
    [self.idCard setText:member.user.idcard];
    
    NSArray *roles = [ExproRole findAll];
    
    for (int i =0;i<roles.count;i++)
    {
        
        ExproRole *role = [roles objectAtIndex:i];    
        if (member.role.gid.intValue == role.gid.intValue)
        {
            [self.roleName setText:role.name];
        }
    }
    
    //获取所在门店的名称
    
    NSArray *allStore = [ExproStore findAll];
    
    for(ExproStore * store in allStore) {
        for (ExproMember * staff in store.staffs) {
            
            if (staff.gid.intValue == member.gid.intValue)
            {
                NSLog(@"self.store.gid.==%i",store.gid.intValue);
                for (int i =0; i < allStore.count ;i++)
                {
                    ExproStore *storeSel = [allStore objectAtIndex:i];
                    [self.storeName setText: storeSel.name];
                }
            }
        }
    }      
} 


-(void)loadMore 
{ 
    NSMutableArray *more; 
    more=[[NSMutableArray alloc] initWithCapacity:0]; 
    NSLog(@"loadMore%i",[self.allPloyee count]);
    if (currentPloyee < [self.allPloyee count])
    {
        for (int i=currentPloyee; i<6+currentPloyee; i++) { 
            if (i < [self.allPloyee count])
            {
                [more addObject:[ self.allPloyee objectAtIndex:i]];    
            }
        } 
        currentPloyee +=6;
        //加载你的数据 
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO]; 
        [self.ployTableView reloadData];
    }
} 


-(void) appendTableWith:(NSMutableArray *)data 
{ 
    for (int i=0 ; i < [data count];i++)
    {
        [self.ployeeItems addObject: [data objectAtIndex:i]];
    }
} 

-(void)showDetail:(id)sender
{
    
    UIButton *selButton = (UIButton *)sender;    
    selectedPloyee = selButton.tag;  
    _currentPloyeeId = selButton.tag;
    ExproMember *member = [self.ployeeItems objectAtIndex:selButton.tag];
    [self.telphone setText: member.user.cellphone];
    [self.name setText:member.user.name];
    [self.idCard setText:member.user.idcard];
    
    NSArray *roles = [ExproRole findAll];
    
    for (int i =0;i<roles.count;i++)
    {
        
        ExproRole *role = [roles objectAtIndex:i];    
        if (member.role.gid.intValue == role.gid.intValue)
        {
            [self.roleName setText:role.name];
        }
    }
    //所属门店
    //获取所在门店的index值
    NSArray *allStore = [ExproStore findAll];
    
    for(ExproStore * store in allStore) {
       
        for (ExproMember * staff in store.staffs) {
               NSLog(@"staff.gid.intValue%i",staff.gid.intValue);
                   NSLog(@"member.gid.intValue%i",member.gid.intValue);
            if (staff.gid.intValue == member.gid.intValue)
            {
                NSLog(@"self.store.gid.==%i",store.gid.intValue);
                NSArray *stores = [ExproStore findAll];
                for (int i =0; i < stores.count ;i++)
                {
                    ExproStore *storeSel = [stores objectAtIndex:i];
                    [self.storeName setText: storeSel.name];
                }
            }
        }
    }
    

    [self.ployTableView reloadData];
}


-(void)deleteSucceed:(id)sender
{
    ExproMember *member = (ExproMember *)sender;
    [member deleteEntity];
    ExproMember *oldmember = [self.allPloyee objectAtIndex:_currentPloyeeId]; 
    [oldmember deleteEntity];
    [[RKObjectManager sharedManager].objectStore save:nil];
    [self viewDidLoad];
    [self.ployTableView reloadData];
}

-(void)deleteFailed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", nil)
                                                    message:NSLocalizedString(@"删除失败", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}


- (IBAction)deletePloyee:(id)sender {
//    _exproStoreDel.reserver = self;
//    _exproStoreDel.succeedCallBack = @selector(deleteSucceed:);
//    _exproStoreDel.failedCallBack = @selector(deleteFailed:);
//    ExproMember *member = [self.memberItems objectAtIndex:_currentMemberId]; 
//    [_exproStoreDel delete:member.gid.stringValue]; 
    
}

- (IBAction)registPloyee:(id)sender {
    ployeeRegistrViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"ployeeRegister"];

    pay.viewController = self;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 800, 650);
}

- (IBAction)modifyPloyee:(id)sender {
    ployeeRegistrViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"ployeeRegister"];

    pay.viewController = self;
    ExproMember *member = [self.allPloyee objectAtIndex:_currentPloyeeId];  
    pay.exproMember = member;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 800, 650);
}



- (IBAction)goBack:(id)sender {
    [self.myRootViewController dismissModalViewControllerAnimated:YES];
}
@end
