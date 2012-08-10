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
@synthesize statusCode=_statusCode;

- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"LoginSucceed", nil) alert:NO succeed:YES];
        //[self addCode:401 info:NSLocalizedString(@"IncorrectPassword", nil) alert:YES succeed:NO];
        [self addCode:403 info:NSLocalizedString(@"ForbidUser", nil) alert:YES succeed:NO];
        
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);
        self.reserver = self;
    }
    return self;
}
- (void)alert:(NSString *)aTitle warning:(NSString *)aWarning {
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:aTitle
                                                         message:aWarning
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [_alertView show];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    
    if (response.statusCode == 401)
    {
        self.statusCode = response.statusCode;
        self.errorTitle = NSLocalizedString(@"Warning", nil);
        [self alert:self.errorTitle warning:NSLocalizedString(@"用户名或密码输入错误", nil)];
    }
    else {
        [super request:request didLoadResponse:response];
    }
}

- (void) signinSucceed:(id)object {
    NSDictionary *user = (NSDictionary *)object;
    NSLog(@"signin user:%@, sex:%@", [user objectForKey:@"name"], [user objectForKey:@"sex"]);    
}

- (void) signin:(NSString *)cellphone password:(NSString *)password 
{
    //RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cellphone,@"cellphone",password,@"password",@"1",@"org", nil];
    
    
    RKManagedObjectMapping* roleMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
   
    [roleMapping mapKeyPathsToAttributes:@"_id", @"gid",nil];
    
    //[objectManager.mappingProvider setMapping:roleMapping forKeyPath:@"role"];
    
    RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [signinMapping mapKeyPathsToAttributes:@"_id", @"gid", @"name", @"name", @"sex", @"sex", nil];
    [signinMapping mapKeyPath:@"role" toRelationship:@"role" withMapping:roleMapping];  
    [self requestURL:@"/signin" method:RKRequestMethodPOST params:params mapping:signinMapping];

}
@end
