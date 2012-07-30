//
//  exproposDealQueryViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"
#import "exproposUpdateDeals.h"
@class ExproDeal;
@class JPStupidButton;
@protocol ButtonClick;

@interface exproposDealQueryViewController : UIViewController <ExproMutableTableViewDataSource,ExproMutableTableViewDelegate,ButtonClick>
@property (strong, nonatomic) IBOutlet UITextField *dealID;
@property (strong, nonatomic) IBOutlet UILabel *dealInfo;
@property (strong, nonatomic) IBOutlet ExproMultipleTableView *dealItemTable;
@property (strong, nonatomic) IBOutlet UIView *keys;
@property (strong, nonatomic) IBOutlet UILabel *dealIDLabel;
@property (strong,nonatomic) exproposUpdateDeals *dealQuery;
@property (strong,nonatomic) ExproDeal *deal;

@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *buttons;


@end
