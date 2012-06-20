//
//  ExproDealViewController.m
//  expropos
//
//  Created by 昊 曹 on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproDealViewController.h"
#import "ExproDealItem.h"
#import "ExproGoods.h"
#import "ExproDeal.h"
#import "ExproDealUploader.h"

@interface ExproDealViewController ()

@end

@implementation ExproDealViewController
@synthesize tableView = _tableView;
@synthesize deal = _deal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

#pragma mark - Expro Table View
- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_deal.items count];
}

- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView {
    return 4;
}

- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment {
    return 0.25;
}

- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment {
    switch (segment) {
        case 0:
            return @"项目";
            break;
        case 1:
            return @"数量";
            break;
        case 2:
            return @"单价";
            break;
        case 3:
            return @"小计";
            break;
        default:
            return nil;
            break;
    }
}

- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"gid" ascending:YES];
    ExproDealItem *_item = [[[_deal items] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] objectAtIndex:indexPath.row];
    CGFloat _width = [self multipleTableView:_tableView proportionForSegment:segment]*_tableView.frame.size.width;
    switch (segment) {
        case 0:{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
            label.text = _item.goods.comment;
            return label;
        }
            break;
        case 1:{
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 11, _width, 21)];
            textField.placeholder = @"";
        }
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    return nil;
}

- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:(NSInteger)section {
    return [UIColor grayColor];
}

@end
