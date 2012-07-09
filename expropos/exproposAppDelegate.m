//
//  exproposAppDelegate.m
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "exproposAppDelegate.h"
#import "exproposRestkit.h"
#import "exproposSysLoad.h"
#import "ExproRole.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproStore.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"

@implementation exproposAppDelegate

@synthesize window = _window;
@synthesize currentUser = _currentUser;
@synthesize sysload=_sysload;
@synthesize sync = _sync;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [exproposRestkit InitRestKit];

   // self.sysload = [exproposSysLoad init];
    //[self.sysload loadSysData:@"1" completion:nil];
    _sync = [[exproposSyncModel alloc] init];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)succeedSync:(id)objects {
//    NSLog(@"sync merchant has got %d objects", objects.count);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:1 forKey:@"merchantID"];
    if ([userDefault integerForKey:@"merchantID"]) {
        self.sync.reserver = self;
        self.sync.succeedCallBack = @selector(succeedSync:);
        [self.sync syncMerchant];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
