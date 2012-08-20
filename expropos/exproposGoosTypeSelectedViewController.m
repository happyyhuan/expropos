//
//  exproposGoosTypeSelectedViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposGoosTypeSelectedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RestKit/RestKit.h"
#import "CoreData/CoreData.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"
#import "ExproMerchant.h"
#import "exproposAppDelegate.h"
#import "ExproMember.h"
#import "exproposGoodsManagerViewController.h"

@interface exproposGoosTypeSelectedViewController ()
@property (strong,nonatomic) NSMutableArray *allDatas;
@property (assign,nonatomic) int selectedRow;
@end


@implementation exproposGoosTypeSelectedViewController
@synthesize datas = _datas;
@synthesize allDatas = _allDatas;
@synthesize merchant = _merchant;
@synthesize selectedRow = _selectedRow;
@synthesize goodsType = _goodsType;
@synthesize vc = _vc;



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
    self.tableView = [self.tableView initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _selectedRow = -1;
	[self loaddata];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)loaddata
{
    exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSArray *members = [ExproMember findAll];
    for(ExproMember *member in members){
        if(member.user.gid == appDelegate.currentUser.gid){
            self.merchant = [member org];
        }
    }
    
    
    NSFetchRequest *request2 = [ExproGoodsType fetchRequest];
    request2.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
    self.allDatas = [[NSArray alloc]initWithArray:[ExproGoodsType objectsWithFetchRequest:request2]];
    
    
    self.datas = [_allDatas mutableCopy];
}



#pragma mark UITableViewDelegate and DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
        int level;
        id obj = [self.datas objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[ExproGoodsType class]]){
            ExproGoodsType *t = (ExproGoodsType*)obj;
            level = t.level.intValue;
        }
        return level;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return self.datas.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
 
    static NSString *CellIdentifier = nil;
    UITableViewCell *cell = nil;
        CellIdentifier=@"showType";
       // cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        id obj = [self.datas objectAtIndex:indexPath.row];
        ExproGoodsType *t = (ExproGoodsType*)obj;
    
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1                                          reuseIdentifier:CellIdentifier];
            
           UIButton *button = nil; button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(240,10, 30, 30);
            button.tag = t.gid.intValue;
            [button addTarget:self action:@selector(selectedGoodsTypes:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
        
        
            cell.textLabel.text = t.name;
            cell.indentationWidth = 20.0f;
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
           
           
            UIImage *image = nil;
            if(t.gid.intValue ==  _goodsType.gid.intValue ){
                image = [UIImage imageNamed:@"checkout.png"];
            }else{
                image = [UIImage imageNamed:@"box.png"];
            }
           
            UIButton *button = (UIButton *)[cell viewWithTag:t.gid.intValue];
            [button setBackgroundImage:image  forState:UIControlStateNormal];
    
    return cell;
    
    
}
-(void)selectedGoodsTypes:(id)sender
{
    int gid = [sender tag];
    for(ExproGoodsType *t in self.datas){
        if(t.gid.intValue == gid){
            _goodsType = t;
        }
    }
    exproposGoodsManagerViewController *egmv = (exproposGoodsManagerViewController*)self.vc;
    if(egmv.selectedGoods){
        egmv.selectedGoods.type = _goodsType;
    }
    egmv.myGoodsType = _goodsType;
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = [self.datas objectAtIndex:indexPath.row];
    
    BOOL isInserted = NO;
    if([obj isKindOfClass:[ExproGoodsType class]]){
        ExproGoodsType *t = (ExproGoodsType*)obj;
        NSSet *set = t.leaves;
        
        for(ExproGoodsType *t in set){
            NSInteger index = [self.datas indexOfObjectIdenticalTo:t];
            isInserted =  (index>0&&index != NSIntegerMax);
            if(isInserted) break;
        }
       
        if(isInserted){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            
            [self removeGoodsTypes:set];
        }else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if(set.count == 0 ){
                cell.imageView.image = [UIImage imageNamed:@"TriangleSmall.png"];
            }else {
                cell.imageView.image = [UIImage imageNamed:@"descending.png"];
            }
            
            NSUInteger count = indexPath.row+1;
            NSMutableArray *arrCells = [NSMutableArray array];
            for(ExproGoodsType *t  in set){
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.datas insertObject:t atIndex:count++];
            }
            
            [tableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
    
    
    
    
}
#pragma mark -

-(void)removeGoodsTypes:(NSSet *)types  
{
    for(ExproGoodsType *t in types){
        
        NSUInteger index = [self.datas indexOfObjectIdenticalTo:t];
        NSSet *set = t.leaves;
        
       
        if(set && set.count>0){
            [self removeGoodsTypes:set];
        }
        if( [self.datas indexOfObjectIdenticalTo:t ]!=NSNotFound){
            [self.datas removeObjectIdenticalTo:t];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    
}



#pragma mark -






@end
