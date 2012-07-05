//
//  exproposSign.m
//  expropos
//
//  Created by gbo on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposSign.h"
#import "ExproUser.h"

@implementation exproposSign


- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"LoginSucceed", nil) alert:NO succeed:YES];
        [self addCode:401 info:NSLocalizedString(@"IncorrectPassword", nil) alert:YES succeed:NO];
        [self addCode:403 info:NSLocalizedString(@"ForbidUser", nil) alert:YES succeed:NO];
        [self addCode:404 info:NSLocalizedString(@"NoSuchUser", nil) alert:YES succeed:NO];
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);
        self.reserver = self;
    }
    return self;
}

- (void) signinSucceed:(id)object {
    NSDictionary *user = (NSDictionary *)object;
    NSLog(@"signin user:%@, sex:%@", [user objectForKey:@"name"], [user objectForKey:@"sex"]);    
}



- (void) signin:(NSString *)cellphone password:(NSString *)password 
{
//    ExproUser *user = [ExproUser object];
//    user.cellphone = cellphone;
//    user.password = password;
//    
//    NSDictionary *prams = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"org",user.cellphone,@"cellphone",user.password,@"password", nil];
//    
////    RKManagedObjectMapping* signinMapping = [RKManagedObjectMapping mappingForClass:[ExproUser class] inManagedObjectStore:[[RKObjectManager sharedManager] objectStore]];
//    RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    [signinMapping mapKeyPathsToAttributes:@"_id", @"gid", nil];
//    [signinMapping mapAttributes:@"name", @"sex", nil];
//    
//    
//    
//
//    [[RKObjectManager sharedManager] sendObject:user toResourcePath:@"/signin" usingBlock:^(RKObjectLoader *loader) {                    
//        loader.method = RKRequestMethodPOST;
//        loader.delegate = self;
//        loader.objectMapping = signinMapping;
//        loader.params = prams;
//    }]; 
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cellphone,@"cellphone",password,@"password",@"1",@"org", nil];
    
    RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [signinMapping mapKeyPathsToAttributes:@"_id", @"gid", @"name", @"name", @"sex", @"sex", nil];
    
    //self.succeedCallBack = @selector(signinSucceed:);
    
    [self requestURL:@"/signin" method:RKRequestMethodPOST params:params mapping:signinMapping];

    
    NSFetchRequest *request = [ExproUser fetchRequest];
    NSPredicate *predicate = nil;
    
    request.predicate = predicate;
    NSArray *deals = [ExproUser objectsWithFetchRequest:request];
    NSLog(@"%i",deals.count);

}
@end
