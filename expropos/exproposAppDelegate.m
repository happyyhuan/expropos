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
@synthesize userName=_userName;
@synthesize gid=_gid;
@synthesize sysload=_sysload;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [exproposRestkit InitRestKit];
    
        //test
       RKObjectManager *manager = [RKObjectManager sharedManager];
        
        
        for(int i=0;i<10;i++){
            ExproGoodsType *type = [ExproGoodsType object];
            type.gid = [NSNumber numberWithInt:i];
            type.name = [NSString stringWithFormat:@"type%i",i];
            [manager.objectStore save:nil];
        }
        
        
        NSArray *d = [ExproGoodsType findAll] ;
        for(int i=0;i<10;i++){
            ExproGoods *g = [ExproGoods object];
            g.gid = [NSNumber numberWithInt:i];
            g.name = [NSString stringWithFormat:@"goods%i",i];
            g.type = [d objectAtIndex:i];
            g.code = [NSString stringWithFormat:@"cod%i",i];
            [manager.objectStore save:nil];
        }
        
   

    
    // Override point for customization after application launch.
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
