//
//  exproposMenuViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
#import "exproposShowDealsSelectedViewController.h"
#import "exproposMemberRegisterController.h"

@interface exproposMenuViewController : UITableViewController 
@property (strong,nonatomic) exproposMainViewController *mainViewController;
@property (strong,nonatomic) NSArray *menus;
@property (strong,nonatomic) exproposShowDealsSelectedViewController *showDeal;
@property (strong,nonatomic) exproposMemberRegisterController *memberRegister;
@end
