//
//  exproposSignout.m
//  expropos
//
//  Created by haitao chen on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposSignout.h"
#import "exproposAppDelegate.h"
#import "exproposMainViewController.h"

@implementation exproposSignout
@synthesize contrller = _contrller;
- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"sigoutSucceed", nil) alert:NO succeed:YES];
        self.succeedTitle = NSLocalizedString(@"sigoutSucceed", nil);
    }
    return self;
}

-(void)signout
{
    [self requestURL:@"/signout" method:RKRequestMethodGET params:nil mapping:nil];
}

-(void)succeedWithoutData
{
    exproposMainViewController *controller = (exproposMainViewController *)_contrller;
    [controller didSignout];
}
@end
