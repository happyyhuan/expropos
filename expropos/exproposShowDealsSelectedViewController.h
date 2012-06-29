//
//  exproposShowDealsViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposDealSelectedViewController.h"

@interface exproposShowDealsSelectedViewController : UITableViewController
@property (strong,nonatomic) UIPopoverController *popover;
@property (strong,nonatomic) UINavigationController *dealSelect;
@property (strong,nonatomic )NSArray *data;
@end
