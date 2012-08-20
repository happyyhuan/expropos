//
//  exproposRoleSelectViewControllerViewController.h
//  expropos
//
//  Created by chen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ployeeRegistrViewController.h"

@interface exproposRoleSelectViewController : UITableViewController
@property (nonatomic,strong) ployeeRegistrViewController *viewController;
@property (nonatomic,strong) NSMutableArray *levelItem;
@end