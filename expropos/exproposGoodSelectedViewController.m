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
    
    NSFetchRequest *request = [ExproMerchant fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %d", @"gid",121212];
    NSArray *merchants = [ExproMerchant objectsWithFetchRequest:request];
    self.merchant = [merchants objectAtIndex:0];
    
    NSFetchRequest *request2 = [ExproGoodsType fetchRequest];
    request2.predicate = [NSPredicate predicateWithFormat:@"%@ = nil", @"parent"];
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
    return 1;
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
    if(self.searchData == nil){
        return self.datas.count;
    }else {
        return self.searchData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
    if(self.searchData == nil){
        CellIdentifier=@"showType";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            cell.textLabel.text = t.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
        }else if([obj isKindOfClass:[ExproGoods class]]){
            ExproGoods *g = (ExproGoods *)obj;
            cell.textLabel.text = g.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"unselected.png"];
        }
    }else {
        CellIdentifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        ExproGoods *g = [self.searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = g.code;
        cell.detailTextLabel.text = g.name;
        cell.imageView.image = [UIImage imageNamed:@"unselected.png"];
    }
    
    return cell;
    
    
}

//选择商品时进行的处理
-(void)tableView:(UITableView *)tableView gooddidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            if(g.type.gid == t.gid){
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
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            
            [self removeGoodsTypes:set Goods:InGoods];
        }else {
            
            NSUInteger count = indexPath.row+1;
            NSMutableArray *arrCells = [NSMutableArray array];
            for(ExproGoodsType *t  in set){
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.imageView.image = [UIImage imageNamed:@"descending.png"];
                
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.datas insertObject:t atIndex:count++];
            }
            for(ExproGoods *g in InGoods){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.datas insertObject:g atIndex:count++];
            }
            
            [tableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
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
            if(g.type.gid == t.gid){
                [theGoddsInT addObject:g];
            }
        }
        if(set && set.count>0){
            [self removeGoodsTypes:set Goods:theGoddsInT];
        }
        if( [self.datas indexOfObjectIdenticalTo:t ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:t];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
    
    for(ExproGoods *g in goods){
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:g];
        if( [self.datas indexOfObjectIdenticalTo:g ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:g];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
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
    NSLog(@"%@",deletes);
    [self.tableView reloadData];
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
@end
