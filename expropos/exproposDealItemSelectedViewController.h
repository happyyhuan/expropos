//
//  exproposDealItemSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposDealSelectedViewController.h"

//exproposDealItemSelectedViewController为交易类型查询控制条件
@interface exproposDealItemSelectedViewController : UITableViewController
@property (nonatomic,strong) exproposDealSelectedViewController *viewController;
@property (nonatomic,strong) NSArray *dealItems;
@end
