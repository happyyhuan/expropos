//
//  exproposDealOperateViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExproMultipleTableView;
@class exproposMemberSelectedViewController;
@class ExproMember;

@interface exproposDealOperateViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealItemTableView;
@property (strong, nonatomic) IBOutlet UIView *scanGoodsView;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) exproposMemberSelectedViewController *memberSelected;
@property (strong, nonatomic) ExproMember *member;

@end
