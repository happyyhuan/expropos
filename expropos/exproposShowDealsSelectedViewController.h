//
//  exproposShowDealsViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"
#import "exproposMainViewController.h"
#import "exproposSign.h"
#import "exproposUpdateDeals.h"

@class exproposDealSelectedViewController;
@interface exproposShowDealsSelectedViewController :UIViewController <ExproMutableTableViewDataSource,ExproMutableTableViewDelegate>
@property (strong,nonatomic) UIPopoverController *popover;
@property (strong,nonatomic) UINavigationController *dealSelect;
@property (strong,nonatomic )NSArray *data;
@property (strong,nonatomic )exproposMainViewController *mainViewController;

@property (nonatomic,strong)IBOutlet ExproMultipleTableView *tableView;
@property (nonatomic,strong) exproposUpdateDeals *updateDeals;


@end
