//
//  exproposStoreViewController.m
//  expropos
//
//  Created by chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "memberManagerViewController.h"
#import "ExproStore.h"
#import "RestKit/RestKit.h"
#import "RestKit/CoreData.h"
#import "expropoStoreEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ExproMember.h"
#import "ExproUser.h"
#import "exproposRegistr.h"

@interface memberManagerViewController ()
@property (nonatomic, strong) exproposRegistr * exproStoreDel;
@end

@implementation memberManagerViewController
@synthesize searchBar = _searchBar;

@synthesize storesTabelView=_storesTabelView;
@synthesize storeDetailView=_storeDetailView;
@synthesize bannerView=_bannerView;
@synthesize queryView=_queryView;
@synthesize memberItems = _memberItems;
@synthesize myRootViewController = _myRootViewController;
@synthesize nameInfo = _nameInfo;
@synthesize addButton = _addButton;
@synthesize modifyButton = _modifyButton;
@synthesize backButton = _backButton;
@synthesize delButton = _delButton;
@synthesize currentMemberId=_currentMemberId;
@synthesize allStore=_allStore;
@synthesize memberRegister=_memberRegister;
@synthesize mainViewControll = _mainViewControll;
@synthesize exproStoreDel = _exproStoreDel;

@synthesize telphone =_telphone;
@synthesize privacy = _privacye;
@synthesize saving=_saving;
@synthesize dueTime = _dueTime;
@synthesize point = _point;

int current = 0;
int selected =0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _allStore = [NSMutableArray arrayWithArray:[ExproMember findAll]];
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:1];
    _memberItems = [[NSMutableArray alloc]initWithCapacity:1];
           for (int i=0; i < self.allStore.count;i++)
        {
            ExproMember *member = [self.allStore objectAtIndex:i];
            if (!member.petName)
            {
                [deletes addObject:member];
            }
        }    
    [self.allStore removeObjectsInArray:deletes];    
    _memberItems = [[NSMutableArray alloc]initWithCapacity:1];    
    for (int i=0 ; i < 6;i++)
    {
        if (i < _allStore.count)
        {
            [self.memberItems addObject: [_allStore objectAtIndex:i]];
            current = 6;      
        }
        else {
            current = _allStore.count;
        }
    }
    
    //---初始化时候显示默认第一条数据的信息
    ExproMember *member = [self.memberItems objectAtIndex:0];
    
    [self.telphone setText: member.user.cellphone];
//    [self.point setText:member.point];
//    [self.saving setText:member.savings];
//    [self.dueTime setText:member.dueTime];
    
    //隐私权限：0：不开放，1：基本信息开放，8:完全开放。
    if (member.privacy.integerValue == 8)
    {
        [self.privacy setText:@"完全开放"];
    }
    else if(member.privacy.integerValue == 0){
         [self.privacy setText:@"不开放"];
    }
    else {
         [self.privacy setText:@"基本信息开放"];
    }
    
    [self.nameInfo setText: member.petName];
    
    
    
    
    //----end
    
    _storesTabelView.layer.cornerRadius = 5.0;
    _storesTabelView.layer.masksToBounds = YES;
    _storesTabelView.layer.borderWidth = 3;
    _storesTabelView.layer.borderColor = [[UIColor grayColor] CGColor];
    _memberRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    //self.mainViewControll = [self.myRootViewController.viewControllers lastObject];
    self.searchBar.delegate = self;
	// Do any additional setup after loading the view.
    if (!_exproStoreDel) {
        _exproStoreDel = [[exproposRegistr alloc]init];
    }
}

- (void)viewDidUnload
{
    [self setStoresTabelView:nil];
    [self setStoreDetailView:nil];
    [self setBannerView:nil];
    [self setQueryView:nil];
    [self setNameInfo:nil];
    [self setPoint:nil];
    [self setPrivacy:nil];
    [self setTelphone:nil];
    [self setSaving:nil];
    [self setDueTime:nil];
    [self setAddButton:nil];
    [self setModifyButton:nil];
    [self setDelButton:nil];
    
    [self setBackButton:nil];
    [self setSearchBar:nil];
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
    int count = [self.memberItems count];
    if (count < [self.allStore count])
    {
        return count+1;  
    }
    else
    {
        return count;
    }
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
    
}

#pragma mark -

-(void)searchWithNameOrId:(NSString *)nameOrId
{
    current = 0 ;
    _allStore = [NSMutableArray arrayWithArray:[ExproMember findAll]];
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:1];
    _memberItems = [[NSMutableArray alloc]initWithCapacity:1];
    if (nameOrId.length != 0)
    {
        for (int i=0; i < self.allStore.count;i++)
        {
            ExproMember *member = [self.allStore objectAtIndex:i];
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
    
    [self.allStore removeObjectsInArray:deletes];
    for (int i=0 ; i < 6;i++)
    {
        if (i < _allStore.count)
        {
            [self.memberItems addObject: [_allStore objectAtIndex:i]];
            current = 6;      
        }
        else {
            current = _allStore.count;
        }
    }
    
    [self.storesTabelView reloadData];
}

#pragma mark -
#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithNameOrId:searchText];    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.storesTabelView reloadData];
    [self.searchBar resignFirstResponder];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if([indexPath row] == ([self.memberItems count])) { 
        //创建loadMoreCell 
        if ([indexPath row] > 5)
        {
            CGRect frame = cell.bounds;
            frame.size.height = 40;
            cell.frame = frame;
            
            
            UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 304, 50)];
            [myLable setText:@"查看更多..."];
            myLable.backgroundColor = [UIColor clearColor ];
            myLable.textColor = [UIColor blackColor];
            
            myLable.font = [UIFont systemFontOfSize: 15];
            
            myLable.textAlignment = UITextAlignmentCenter;
            
            myLable.layer.cornerRadius = 5.0;
            myLable.layer.masksToBounds = YES;
            myLable.layer.borderWidth = 3;
            myLable.layer.borderColor = [[UIColor grayColor] CGColor];
            myLable.tag = indexPath.row;
            myLable.backgroundColor = [ UIColor clearColor];
            
            [cell addSubview:myLable]; 
            
        }
    }else { 
        
        
        CGRect frame = cell.bounds;
        
        frame.size.height = 100;
        frame.size.width = frame.size.width-80;
        frame.origin.x = frame.origin.x + 80;
        UILabel *myLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
        [myLable setText:[NSString stringWithFormat:@"%i",indexPath.row]];
        myLable.backgroundColor = [UIColor clearColor ];
        myLable.textColor = [UIColor redColor];
        
        myLable.font = [UIFont systemFontOfSize: 15];
        
        myLable.textAlignment = UITextAlignmentCenter;
        
        myLable.layer.cornerRadius = 5.0;
        myLable.layer.masksToBounds = YES;
        myLable.layer.borderWidth = 3;
        myLable.layer.borderColor = [[UIColor grayColor] CGColor];
        myLable.tag = indexPath.row;
        
        UIButton *myButton =[UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = frame;
        ExproMember *member = [self.memberItems objectAtIndex:indexPath.row];
        myButton.titleLabel.text =member.petName;
        
        if (selected == indexPath.row)
        {
            myButton.backgroundColor = [UIColor yellowColor];
            myLable.backgroundColor = [UIColor yellowColor];
        }
        else {
            myButton.backgroundColor = [UIColor grayColor];
            myLable.backgroundColor = [UIColor grayColor];
        }
        
        [myButton setTitle:member.petName forState:UIControlStateNormal];
        
        [myButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        myButton.tag = indexPath.row;
        myButton.layer.cornerRadius = 5.0;
        myButton.layer.masksToBounds = YES;
        myButton.layer.borderWidth = 3;
        myButton.layer.borderColor = [[UIColor grayColor] CGColor];        
        [cell addSubview:myButton];
        [cell addSubview:myLable];
        
        
    } 
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] == ([self.memberItems count])) { 
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath]; 
        loadMoreCell.textLabel.text=@"loading more …"; 
        [self performSelectorInBackground:@selector(loadMore) withObject:nil]; 
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
        return; 
    } 
} 


-(void)loadMore 
{ 
    NSMutableArray *more; 
    more=[[NSMutableArray alloc] initWithCapacity:0]; 
    NSLog(@"loadMore%i",[self.allStore count]);
    if (current < [self.allStore count])
    {
        for (int i=current; i<6+current; i++) { 
            if (i < [self.allStore count])
            {
                [more addObject:[ self.allStore objectAtIndex:i]];    
            }
        } 
        current +=6;
        //加载你的数据 
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO]; 
        [self.storesTabelView reloadData];
    }
} 


-(void) appendTableWith:(NSMutableArray *)data 
{ 
    for (int i=0 ; i < [data count];i++)
    {
        [self.memberItems addObject: [data objectAtIndex:i]];
    }
} 

-(void)showDetail:(id)sender
{
    
    UIButton *selButton = (UIButton *)sender;    
    selected = selButton.tag;  
    _currentMemberId = selButton.tag;
    ExproMember *member = [self.memberItems objectAtIndex:selButton.tag];
    
    [self.telphone setText: member.user.cellphone];
//    [self.point setText:member.point];
//    [self.saving setText:member.savings];
//    [self.dueTime setText:member.dueTime];
    
    //隐私权限：0：不开放，1：基本信息开放，8:完全开放。
    if (member.privacy.integerValue == 8)
    {
        [self.privacy setText:@"完全开放"];
    }
    else if(member.privacy.integerValue == 0){
        [self.privacy setText:@"不开放"];
    }
    else {
        [self.privacy setText:@"基本信息开放"];
    }

    [self.nameInfo setText: member.petName];
    [self.storesTabelView reloadData];
}



- (IBAction)addMember:(id)sender {
    exproposMemberRegisterController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    
    pay.viewController = self;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 800, 650);
}

- (IBAction)modifyMember:(id)sender {
    exproposMemberRegisterController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"memberRegister"];
    
    pay.viewController = self;
    ExproMember *member = [self.memberItems objectAtIndex:_currentMemberId];  
    pay.exproMember = member;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 800, 650);
}

- (IBAction)backToMemu:(id)sender {
    [self.myRootViewController dismissModalViewControllerAnimated:YES];
}


-(void)deleteSucceed:(id)sender
{
    ExproMember *member = (ExproMember *)sender;
    [member deleteEntity];
    ExproMember *oldmember = [self.memberItems objectAtIndex:_currentMemberId]; 
    [oldmember deleteEntity];
    [[RKObjectManager sharedManager].objectStore save:nil];
    [self viewDidLoad];
    [self.storesTabelView reloadData];
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


- (IBAction)delMember:(id)sender {
//    exproposRegistr *exproStoreDel = [[exproposRegistr alloc]init];
    _exproStoreDel.reserver = self;
    _exproStoreDel.succeedCallBack = @selector(deleteSucceed:);
    _exproStoreDel.failedCallBack = @selector(deleteFailed:);
    ExproMember *member = [self.memberItems objectAtIndex:_currentMemberId]; 
    [_exproStoreDel delete:member.gid.stringValue]; 

}
@end
