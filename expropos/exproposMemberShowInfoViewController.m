//
//  exproposMemberShowInfoViewController.m
//  expropos
//
//  Created by haitao chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMemberShowInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ExproMember.h"
#import "ExproUser.h"

@interface exproposMemberShowInfoViewController ()

@end

@implementation exproposMemberShowInfoViewController
@synthesize member = _member;
@synthesize button = _button;

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
    [self.tableView initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
    
    self.tableView.layer.cornerRadius = 10.0;
    self.tableView.layer.masksToBounds = YES;
	self.tableView.layer.borderWidth = 3;
    self.tableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    NSLog(@"vd");
    
}

-(void)viewWillAppear:(BOOL)animated
{
   [ self addObserver:self forKeyPath:@"member" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    int row = indexPath.row;
    switch (row) {
        case 0:
            cell.textLabel.text = @"昵称：";
            cell.detailTextLabel.text = [_member petName];
            break;
        case 1:
            cell.textLabel.text = @"姓名：";
            cell.detailTextLabel.text = _member.user.name;
            break;
        case 2:
            cell.textLabel.text = @"性别：";
            cell.detailTextLabel.text = _member.user.sex.intValue == 0? @"女":@"男";
            break;
        case 3:
            cell.textLabel.text = @"电话：";
            cell.detailTextLabel.text = _member.user.cellphone;
            break;
        case 4:
            cell.textLabel.text = @"积分：";
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%i", _member.point.intValue];
            break;
        case 5:
            cell.textLabel.text = @"储值：";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%g",_member.savings.doubleValue];
            break;
        case 6:
            cell.textLabel.text = @"email：";
            cell.detailTextLabel.text = _member.user.email;
            break;  
        case 7:
            cell.textLabel.text = @"开户时间：";
            cell.detailTextLabel.text = [self dateToStr:_member.user.createTime];
            break;
                default:
            break;
    }
    
    return cell;
}

-(NSString *)dateToStr:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return @"会员详细信息明细表：";
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
