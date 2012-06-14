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

- (void) signIn:(NSString *)cellphone password:(NSString *)password 
{
    ExproUser *user = [ExproUser object];
    user.cellphone = cellphone;
    user.password = password;
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/signin" usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        loader.delegate = self;
        loader.params = nil;
    }]; 
}
@end
