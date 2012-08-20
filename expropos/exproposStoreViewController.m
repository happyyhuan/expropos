//
//  exproposStoreViewController.m
//  expropos
//
//  Created by chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposStoreViewController.h"
#import "ExproStore.h"
#import "RestKit/RestKit.h"
#import "RestKit/CoreData.h"
#import "expropoStoreEditViewController.h"
#import "ExproMerchant.h"
#import "exproposAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface exproposStoreViewController ()
@property (nonatomic, strong) exproposStoreEdit *exproStoreDel;
@end

@implementation exproposStoreViewController
@synthesize searchBar = _searchBar;

@synthesize storesTabelView=_storesTabelView;
@synthesize storeDetailView=_storeDetailView;
@synthesize bannerView=_bannerView;
@synthesize queryView=_queryView;
@synthesize storeItems = _storeItems;

@synthesize myRootViewController = _myRootViewController;
@synthesize nameInfo = _nameInfo;
@synthesize addButton = _addButton;
@synthesize modifyButton = _modifyButton;
@synthesize backButton = _backButton;
@synthesize delButton = _delButton;
@synthesize currentStoreId=_currentStoreId;
@synthesize allStore=_allStore;
@synthesize exproStoreDel =_exproStoreDel;
@synthesize storeAddress =_storeAddress;
@synthesize storeState = _storeState;
@synthesize storeNotice = _storeNotice;
@synthesize storeTrainInfo =_storeTrainInfo;
@synthesize storeNO = _storeNo;
@synthesize storeComment = _storeComment;
int currentIndex = 0;
int selectIndex =0;



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
       //查找该商户的所有门店
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
    
    
   _allStore = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i =0;i<merchants.count;i++)
    {
        ExproMerchant *merchant = [merchants objectAtIndex:i];  
        NSSet *stores = merchant.stores;
        for(ExproStore *item in stores){
            [_allStore addObject:item]; 
        }
    }
 
    _storeItems = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i=0 ; i < 6;i++)
    {
        if (i < _allStore.count)
        {
            [self.storeItems addObject: [_allStore objectAtIndex:i]];
            currentIndex = 6;      
        }
        else {
            currentIndex = _allStore.count;
        }
    }
    
    //---初始化时候显示默认第一条数据的信息
    if (self.storeItems.count !=0)
    {
        ExproStore *store = [self.storeItems objectAtIndex:0];
    
        [self.nameInfo setText: store.name];
        [self.storeNO setText: store.districtCode];
        [self.storeAddress setText:store.address];
        [self.storeComment setText:store.comment];
        [self.storeNotice setText:store.notice];
        [self.storeTrainInfo setText:store.transitInfo];    //----end
    }
    _storesTabelView.layer.cornerRadius = 5.0;
    _storesTabelView.layer.masksToBounds = YES;
    _storesTabelView.layer.borderWidth = 3;
    _storesTabelView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.searchBar.delegate = self;
    
    if (!_exproStoreDel)
    {
        _exproStoreDel=[[exproposStoreEdit alloc]init];

    }
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setStoresTabelView:nil];
    [self setStoreDetailView:nil];
    [self setBannerView:nil];
    [self setQueryView:nil];
    
    [self setNameInfo:nil];
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
    int count = [self.storeItems count];
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

-(void)searchWithNameOrId:(NSString *)nameOrId
{
    currentIndex = 0 ;
    //查找该商户的所有门店
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
    
    
    _allStore = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i =0;i<merchants.count;i++)
    {
        ExproMerchant *merchant = [merchants objectAtIndex:i];  
        NSSet *stores = merchant.stores;
        for(ExproStore *item in stores){
            [_allStore addObject:item]; 
        }
    }
    
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:1];
    _storeItems = [[NSMutableArray alloc]initWithCapacity:1];
    if (nameOrId.length != 0)
    {
        for (int i=0; i < self.allStore.count;i++)
        {
            ExproStore *good = [self.allStore objectAtIndex:i];
            if([good.name rangeOfString:nameOrId ].location == NSNotFound)
            {
                [deletes addObject:good];
            }
        }
    }
   
    [self.allStore removeObjectsInArray:deletes];
    for (int i=0 ; i < 6;i++)
    {
        if (i < _allStore.count)
        {
            [self.storeItems addObject: [_allStore objectAtIndex:i]];
            currentIndex = 6;      
        }
        else {
            currentIndex = _allStore.count;
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
    if([indexPath row] == ([self.storeItems count])) { 
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
        myButton.titleLabel.text = [[self.storeItems objectAtIndex:indexPath.row] name];
        
        if (selectIndex == indexPath.row)
        {
            NSLog(@"select INDEX === %i",selectIndex);
            myButton.backgroundColor = [UIColor yellowColor];
            myLable.backgroundColor = [UIColor yellowColor];
        }
        else {
            myButton.backgroundColor = [UIColor grayColor];
            myLable.backgroundColor = [UIColor grayColor];
        }
       
        [myButton setTitle:[[self.storeItems objectAtIndex:indexPath.row] name] forState:UIControlStateNormal];
        
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
    
   if([indexPath row] == ([self.storeItems count])) { 
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
    if (currentIndex < [self.allStore count])
    {
        for (int i=currentIndex; i<6+currentIndex; i++) { 
            if (i < [self.allStore count])
            {
                [more addObject:[ self.allStore objectAtIndex:i]];    
            }
        } 
    currentIndex +=6;
    //加载你的数据 
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO]; 
    [self.storesTabelView reloadData];
    }
} 


-(void) appendTableWith:(NSMutableArray *)data 
{ 
    for (int i=0 ; i < [data count];i++)
        {
            [self.storeItems addObject: [data objectAtIndex:i]];
        }
} 



-(void)showDetail:(id)sender
{
    
    UIButton *selButton = (UIButton *)sender;    
    selectIndex = selButton.tag;  
    _currentStoreId = selButton.tag;
    
    ExproStore *store = [self.storeItems objectAtIndex:selButton.tag];
    [self.nameInfo setText: store.name];
    [self.storeNO setText: store.districtCode];
    [self.storeAddress setText:store.address];
    [self.storeComment setText:store.comment];
    [self.storeNotice setText:store.notice];
    [self.storeTrainInfo setText:store.transitInfo];
//    门店状态选择：1-正常状态说明此门店正常营业；0-封闭状态说明门店可能暂时停业整修等。2-公开：门店可以被其他商户及公众立刻可见。3-不公开：门店不可以被其他商户及公众可见（等待现实中的新店开业后再公开，或者等待新店相关系统配置工作完成后再公开。）
    if(store.state.integerValue == 1)
    {
        [self.storeState setText:@"正常营业"];
    }
    else {
        [self.storeState setText:@"暂时停业"];
    }
    [self.storesTabelView reloadData];
}



- (IBAction)addStore:(id)sender {
    expropoStoreEditViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"storeEditView"];
    pay.storeView = self;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 600, 450);
}

- (IBAction)modifyStore:(id)sender {
    expropoStoreEditViewController *pay = [self.storyboard instantiateViewControllerWithIdentifier:@"storeEditView"];
    pay.storeView = self;
    ExproStore *store = [self.storeItems objectAtIndex:_currentStoreId];
    pay.exproStore = store;
    pay.modalPresentationStyle = UIModalPresentationFormSheet;
    pay.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    [self presentModalViewController:pay animated:YES];
    pay.view.superview.frame = CGRectMake(100,250, 600, 450);
}

- (IBAction)backToMemu:(id)sender {
    [self.myRootViewController dismissModalViewControllerAnimated:YES];
}


-(void)deleteSucceed:(id)sender
{
    ExproStore *newStore = (ExproStore *)sender;
    [newStore deleteEntity];
    ExproStore *store = [self.storeItems objectAtIndex:_currentStoreId];
    [store deleteEntity];

    
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

- (IBAction)delStore:(id)sender {
    //exproposStoreEdit *exproStoreDel = [[exproposStoreEdit alloc]init];
    self.exproStoreDel.reserver = self;
    self.exproStoreDel.succeedCallBack = @selector(deleteSucceed:);
    self.exproStoreDel.failedCallBack = @selector(deleteFailed:);
    ExproStore *store = [self.storeItems objectAtIndex:_currentStoreId];
    [self.exproStoreDel storeDelete:store.gid.integerValue]; 
    
}
@end
