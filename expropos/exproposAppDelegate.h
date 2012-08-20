//
//  exproposAppDelegate.h
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposSysLoad.h"
#import "exproposSyncModel.h"
#import "ExproUser.h"

@interface exproposAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) ExproUser * currentUser;
@property (strong) exproposSysLoad * sysload;
@property (strong) exproposSyncModel * sync;
@property (nonatomic,strong) NSString *currentOrgid;

@end
