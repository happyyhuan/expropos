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
    
    //test
    RKObjectManager *manager = [RKObjectManager sharedManager];
     
     
     for(int i=0;i<10;i++){
     ExproRole *r = [ExproRole object];
     r.gid = [NSNumber numberWithInt:i];
     r.name = [NSString stringWithFormat:@"role %i",i];
     [manager.objectStore save:nil];
     }
     
     
     NSArray *d = [ExproRole findAll] ;
     for(int i=0;i<10;i++){
     ExproMember *m = [ExproMember object];
     m.gid = [NSNumber numberWithInt:(24+i)];
     m.petName = [NSString stringWithFormat:@"petName %i",m.gid.intValue];
     m.role = [d objectAtIndex:i];
         m.savings = [NSNumber numberWithInt:i];
         m.point = [NSNumber numberWithInt:i];
     ExproUser *user = [ExproUser object];
     user.cellphone = [NSString stringWithFormat:@"1876182900%i",i];
     user.gid = [NSNumber numberWithInt:i];
         user.createTime = [NSDate date];
         user.password = @"123456";
     m.user= user;
     
     [manager.objectStore save:nil];
     }
   
     
     for(int i=0;i<10;i++){
     ExproStore *store = [ExproStore object];
     store.gid = [NSNumber numberWithInt:i];
     store.name = [NSString stringWithFormat:@"name%i",i];
     [[[RKObjectManager sharedManager] objectStore]save:nil];
     }
     
     
    //test
    //RKObjectManager *manager = [RKObjectManager sharedManager];
    for(int i=0;i<10;i++){
        ExproGoodsType *type = [ExproGoodsType object];
        type.gid = [NSNumber numberWithInt:i];
        type.name = [NSString stringWithFormat:@"type %i",i];
        
        [manager.objectStore save:nil];
    }
    for(int i=0;i<10;i++){
        ExproGoods *g = [ExproGoods object];
        g.gid = [NSNumber numberWithInt:i];
        g.name = [NSString stringWithFormat:@"goods%i",i];
        g.price = [NSNumber numberWithInt:20];
        NSArray *types = [ExproGoodsType findAll];
        g.type = [types objectAtIndex:i];
        g.code = [NSString stringWithFormat:@"code %i",i];
        [manager.objectStore save:nil];
    }
    //test end

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
