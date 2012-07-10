//
//  exproposDealSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproMember.h"
#import "exproposUpdateDeals.h"

@class exproposShowDealsSelectedViewController;

@interface exproposDealSelectedViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic,strong) exproposShowDealsSelectedViewController  *showDeals;
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) NSDate *beginDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSString *fromAmoutOfMoney;
@property (nonatomic,strong) NSString *endAmoutOfMoney;
@property (nonatomic,strong) NSMutableArray *members;
@property (nonatomic,strong) NSMutableArray *dealItems;
@property (nonatomic,strong) NSMutableArray *stores;
@property (nonatomic,strong) NSMutableArray *payTypes;
@property (nonatomic,strong) exproposUpdateDeals *update;
@property (nonatomic,strong) UIPopoverController *myPopover;
@property (nonatomic,strong)  NSMutableArray *deals;

-(void) searchInLoacl;
-(void)dealSelect;
@end
