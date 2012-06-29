//
//  exproposMenuViewController.m
//  expropos
//
//  Created by haitao chen on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMenuViewController.h"
#import "exproposDealSelectedViewController.h"

@interface exproposMenuViewController ()

@end

@implementation exproposMenuViewController
@synthesize menus = _menus;
@synthesize mainViewController = _mainViewController;
@synthesize nav = _nav;


- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menus = [NSArray arrayWithObjects:@"消费", @"充值", @"积分", @"交易查询", @"会员开户", nil];

    self.mainViewController = [self.splitViewController.viewControllers lastObject];
    _nav = [self.storyboard instantiateViewControllerWithIdentifier:@"showDeals"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.menus objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString *menu = [self.menus objectAtIndex:row];
    if([menu isEqualToString:@"交易查询"]){
        
        _nav.view.frame=CGRectMake(0, 50, self.mainViewController.view.bounds.size.width-100 , self.mainViewController.view.bounds.size.height-100);
    [[[self.splitViewController.viewControllers objectAtIndex:1] view] insertSubview:_nav.view atIndex:1];
       
    }
   

    
   
}




@end
