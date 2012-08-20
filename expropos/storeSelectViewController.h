//
//  storeSelectViewController.h
//  expropos
//
//  Created by chen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ployeeRegistrViewController.h"

@interface storeSelectViewController : UITableViewController
@property (nonatomic,strong) ployeeRegistrViewController *viewController;
@property (nonatomic,strong) NSMutableArray *storeItem;
@property (nonatomic,strong) NSMutableArray *allStoreItem;
@end
