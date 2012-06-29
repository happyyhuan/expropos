//
//  exproposUpdateDeals.m
//  expropos
//
//  Created by haitao chen on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposUpdateDeals.h"

@implementation exproposUpdateDeals
//200 OK & application/json, 204 Not Content, 401 Unauthorized
- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"UpdateSucceed", nil) alert:NO succeed:YES];
        [self addCode:204 info:NSLocalizedString(@"Not Content", nil) alert:YES succeed:NO];
        [self addCode:401 info:NSLocalizedString(@"Unauthorized", nil) alert:YES succeed:NO];
        self.succeedTitle = NSLocalizedString(@"UpDateSucceed", nil);
        self.errorTitle = NSLocalizedString(@"UpdateFailed", nil);
        self.reserver = self;
    }
    return self;
}



-(void)upDateDealStart:(int)start end:(int)end bt:(NSDate*)bt et:(NSDate*)et
{
 
    NSString *url = [NSString stringWithFormat:@"/deals?bt=%@&et=%@",bt,et];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url delegate:self];
    
}



@end
