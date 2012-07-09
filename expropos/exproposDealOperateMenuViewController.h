//
//  exproposDealOperateMenuViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMyTableView.h"
@protocol MyTableViewDataSource;
@protocol MyTableViewDelegate;
@class exproposMemberSelectedViewController;
@class ExproMember;
@class exproposDealOperateViewController;

@interface exproposDealOperateMenuViewController : UIViewController <MyTableViewDelegate,MyTableViewDataSource>
@property (strong, nonatomic) IBOutlet exproposMyTableView *menuTableView;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) exproposMemberSelectedViewController *memberSelected;
@property (strong, nonatomic) exproposDealOperateViewController *dealOperate;
@property (nonatomic) double getMeony;
@end


