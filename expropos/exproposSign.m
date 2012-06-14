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

- (void) signin:(NSString *)cellphone password:(NSString *)password 
{
    ExproUser *user = [ExproUser object];
    user.cellphone = cellphone;
    user.password = password;
    
    RKObjectMapping *signinSerializationMapping = [RKObjectMapping mappingForClass:[ExproUser class]];
    [signinSerializationMapping mapAttributes:@"cellphone", @"password", nil];

    [[RKObjectManager sharedManager] sendObject:user toResourcePath:@"/signin" usingBlock:^(RKObjectLoader *loader) {                    
        loader.method = RKRequestMethodPOST;
        loader.delegate = self;
        loader.serializationMapping = signinSerializationMapping;
    }]; 
}
@end
