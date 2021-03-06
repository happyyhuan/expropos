//
//  ViewController.m
//  Demo1
//
//  Created by haitao chen on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposGoodSelectedViewController.h"
#import "RestKit/RestKit.h"
#import "CoreData/CoreData.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"
#import "ExproMerchant.h"
#import "exproposAppDelegate.h"
#import "ExproMember.h"
#import "exproposShowDealOperateViewController.h"

@interface exproposGoodSelectedViewController ()
@property (nonatomic,strong)ExproMerchant *merchant;
@end

@implementation exproposGoodSelectedViewController
@synthesize allDatas = _allDatas;
@synthesize datas = _datas;
@synthesize searchData = _searchData;
@synthesize searchBar = _searchBar;
@synthesize merchant = _merchant;
@synthesize viewController = _viewController;
@synthesize sync = _sync;
@synthesize mySelectedGoods = _mySelectedGoods;
@synthesize FlashButton = _FlashButton;

-(void)viewWillAppear:(BOOL)animated
{
    if([_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
        exproposShowDealOperateViewController *dealOperate = (exproposShowDealOperateViewController *)_viewController;
        _mySelectedGoods = [NSMutableArray arrayWithArray:[dealOperate.mySelectedGoods mutableCopy]];
    }else{
        _mySelectedGoods = [NSMutableArray arrayWithCapacity:20];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    if([_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
        exproposShowDealOperateViewController *dealOperate = (exproposShowDealOperateViewController *)_viewController;
        NSMutableDictionary *newGoodsAndAmount = [[NSMutableDictionary alloc] initWithDictionary:dealOperate.goodsAndAmount copyItems:YES];
        [dealOperate.goodsAndAmount removeAllObjects];
        for(ExproGoods *g in _mySelectedGoods){
            int num =  [[newGoodsAndAmount objectForKey:g.gid] intValue];
            if(num <=0){
                num =1;
            }
            [dealOperate.goodsAndAmount setObject:[NSNumber numberWithInt:num] forKey:g.gid];
        }
        dealOperate.mySelectedGoods = _mySelectedGoods;
        dealOperate.isPopover = NO;
        dealOperate.goodsCode.text = @"";
    }

}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentSizeForViewInPopover = CGSizeMake(300, 310);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self loaddata];
    
}


-(void)reloadDatas
{
    [self.tableView reloadData];
}
-(void)loaddata
{
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    

    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid.intValue == appDelegate.currentUser.gid.intValue){
            self.merchant = member.org;
        }
    }
     
     
     NSFetchRequest *request2 = [ExproGoodsType fetchRequest];
     request2.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
     self.allDatas = [[NSArray alloc]initWithArray:[ExproGoodsType objectsWithFetchRequest:request2]];
   
    
    self.datas = [_allDatas mutableCopy];
}

- (void)viewDidUnload
{
    self.allDatas = nil;
    self.datas = nil;
    self.searchData = nil;
    self.searchBar = nil;
    self.merchant = nil;
    [self setFlashButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -


#pragma mark UITableViewDelegate and DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchData == nil){
        int level;
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            level = t.level.intValue;
        }else if([obj isKindOfClass:[ExproGoods class]]){
            ExproGoods *g = (ExproGoods *)obj;
            level = g.type.level.intValue+1;
        }
        return level;
    }
    return 0;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    
    if(self.searchData == nil){
        return self.datas.count==0 ? 1:self.datas.count;
    }else {
        return self.searchData.count==0 ? 1:self.searchData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if(indexPath.section ==0){
        
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
      
        if([_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
            cell.textLabel.text  =  @"请选择商品 重复选择即视为取消！ ";
            return cell;
        }
        
        cell.textLabel.text = @"所有商品";
        if([_mySelectedGoods count]==0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    if(self.searchData == nil){
        CellIdentifier=@"showType";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        if(self.datas.count == 0){
            cell.textLabel.text = @"sorry！查无数据！";
             cell.detailTextLabel.text = @"";
            return cell;
        }
        
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            cell.textLabel.text = t.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"3未展开.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if([obj isKindOfClass:[ExproGoods class]]){
            ExproGoods *g = (ExproGoods *)obj;
            cell.textLabel.text = g.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"2商品.png"];
            if([_mySelectedGoods containsObject:g]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }else {
        CellIdentifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        if(self.searchData.count == 0){
            cell.textLabel.text = @"sorry！查无数据！";
            cell.detailTextLabel.text = @"";
            return cell;
        }
        
        ExproGoods *g = [self.searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = g.code;
        cell.detailTextLabel.text = g.name;
        cell.imageView.image = [UIImage imageNamed:@"2商品.png"];
        if([_mySelectedGoods containsObject:g]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
    
    
}

//选择商品时进行的处理
-(void)tableView:(UITableView *)tableView gooddidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
     
        if([_viewController isKindOfClass:[exproposShowDealOperateViewController class]]){
            return;
        }
        [_mySelectedGoods removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.textLabel.text isEqualToString:@"sorry！查无数据！"]){
        return;
    }
    if(self.searchData!=nil){
        if([_mySelectedGoods containsObject:[self.searchData objectAtIndex:indexPath.row]]){
            [_mySelectedGoods removeObject:[self.searchData objectAtIndex:indexPath.row]];
        }else {
            [_mySelectedGoods addObject:[self.searchData objectAtIndex:indexPath.row]];
        }
    }else {
        if([_mySelectedGoods containsObject:[self.datas objectAtIndex:indexPath.row]]){
            [_mySelectedGoods removeObject:[self.datas objectAtIndex:indexPath.row]];
        }else {
            [_mySelectedGoods addObject:[self.datas objectAtIndex:indexPath.row]];
        }
    }
    
    [self.tableView reloadData];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
        return ;
    }
    if(self.searchData!=nil){
        [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = [self.datas objectAtIndex:indexPath.row];
    
    BOOL isInserted = NO;
    if([obj isKindOfClass:[ExproGoodsType class]]){
        ExproGoodsType *t = (ExproGoodsType*)obj;
        NSSet *set = t.leaves;
        NSMutableArray *InGoods = [[NSMutableArray alloc] initWithCapacity:20];
        for(ExproGoods *g in self.merchant.goods){
            if(g.type.gid.intValue == t.gid.intValue){
                [InGoods addObject:g];
            }
        }
        
        for(ExproGoodsType *t in set){
            NSInteger index = [self.datas indexOfObjectIdenticalTo:t];
            isInserted =  (index>0&&index != NSIntegerMax);
            if(isInserted) break;
        }
        for(ExproGoods *g in InGoods){
            NSInteger index = [self.datas indexOfObjectIdenticalTo:g];
            
            isInserted = isInserted || (index>0&&index != NSIntegerMax);
            if(isInserted) break;
        }
        
        
        if(isInserted){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"3未展开.png"];
            
            [self removeGoodsTypes:set Goods:InGoods];
        }else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if(set.count == 0 && InGoods.count == 0){
                cell.imageView.image = [UIImage imageNamed:@"3未展开.png"];
            }else {
               cell.imageView.image = [UIImage imageNamed:@"1展开.png"];
            }
            
            NSUInteger count = indexPath.row+1;
            NSMutableArray *arrCells = [NSMutableArray array];
            for(ExproGoodsType *t  in set){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                [self.datas insertObject:t atIndex:count++];
            }
            for(ExproGoods *g in InGoods){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                [self.datas insertObject:g atIndex:count++];
            }
            
            [tableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }else if([obj isKindOfClass:[ExproGoods class]]){
       [self tableView:tableView gooddidSelectRowAtIndexPath:indexPath];
    }
    
    
    
    
}
#pragma mark -

-(void)removeGoodsTypes:(NSSet *)types Goods:(NSArray *)goods 
{
    for(ExproGoodsType *t in types){
        
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:t];
        NSSet *set = t.leaves;
       
        NSMutableArray *theGoddsInT = [[NSMutableArray alloc]initWithCapacity:20];
        for(ExproGoods *g in self.merchant.goods){
            if(g.type.gid.intValue == t.gid.intValue){
                [theGoddsInT addObject:g];
            }
        }
        if(theGoddsInT.count >0 ||(set && set.count>0)){
            [self removeGoodsTypes:set Goods:theGoddsInT];
        }
        if( [self.datas indexOfObjectIdenticalTo:t ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:t];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    for(ExproGoods *g in goods){
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:g];
        if( [self.datas indexOfObjectIdenticalTo:g ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:g];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}



#pragma mark -


#pragma mark search methods
-(void)reset
{
    
    NSMutableArray *tmpdata = [[NSMutableArray alloc]initWithCapacity:100];
    NSSet *set = [self.merchant goods];
    for(ExproGoods *g in set){
        [tmpdata addObject:g];
    }
    self.searchData = [tmpdata mutableCopy];
  
}

-(void)searchWithNameOrId:(NSString *)nameOrId
{
    [self reset];
    NSMutableArray *deletes = [[NSMutableArray alloc]initWithCapacity:20];
    for(ExproGoods *good in self.searchData){
        if([good.name rangeOfString:nameOrId ].location == NSNotFound &&
           [good.code rangeOfString:nameOrId].location == NSNotFound)
        {
            [deletes addObject:good];
        }
    }
    
    [self.searchData removeObjectsInArray:deletes];
    [self reloadDatas];
}



#pragma mark -
#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length >0){
        [self searchWithNameOrId:searchText];
    }else {
        self.searchData = nil;
        [self.tableView reloadData];
    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchData = nil;
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}


#pragma mark -

- (IBAction)update:(UIBarButtonItem *)sender {
  
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("information downloader", NULL);
    dispatch_async(downloadQueue, ^{
        _sync = [[exproposSyncModel alloc] init];
        _sync.reserver = self;
        _sync.succeedCallBack = @selector(updateSuccess);
//        exproposAppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
//        NSString *gidstr = [NSString stringWithFormat:@"%i",appdelegate.currentUser.gid.intValue];
        //[_sysLoad loadSysData:gidstr completion:nil];
        [_sync syncMerchant];
    });
    dispatch_release(downloadQueue);    
}

-(void)updateSuccess
{
    self.navigationItem.rightBarButtonItem = _FlashButton;
    [self loaddata];
    [self.tableView reloadData];
}

@end
