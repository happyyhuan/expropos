//
//  exproposAppDelegate.h
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposSysLoad.h"

@interface exproposAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) NSString *userName;
@property (nonatomic, retain) NSString * gid;
@property (strong) exproposSysLoad *sysload;

@end
