//
//  exproposLeverSelectViewController.h
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMemberRegisterController.h"

@interface exproposLeverSelectViewController : UITableViewController
@property (nonatomic,strong) exproposMemberRegisterController *viewController;
@property (nonatomic,strong) NSArray *levelItem;
@end
