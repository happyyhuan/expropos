//
//  exproposStoreStateController.h
//  expropos
//
//  Created by chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "expropoStoreEditViewController.h"

@interface exproposStoreStateController : UITableViewController

@property (nonatomic,strong) expropoStoreEditViewController *viewController;
@property (nonatomic,strong) NSArray *levelItem;
@end
