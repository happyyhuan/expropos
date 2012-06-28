//
//  exproposSysLoad.m
//  expropos
//
//  Created by chen on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposSysLoad.h"

@implementation exproposSysLoad


- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"LoginSucceed", nil) alert:NO succeed:YES];
        [self addCode:401 info:NSLocalizedString(@"IncorrectPassword", nil) alert:YES succeed:NO];
        [self addCode:403 info:NSLocalizedString(@"ForbidUser", nil) alert:YES succeed:NO];
        [self addCode:404 info:NSLocalizedString(@"NoSuchUser", nil) alert:YES succeed:NO];
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);    }
    return self;
}

- (void) loadSysData:(NSString*)gid     
          completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //实现同步数据代码    
        NSLog(@"实现同步数据代码 ");
        NSString *_resource = [NSString stringWithFormat:@"/sync/merchants/%qu",gid];
        [self requestURL:_resource method:RKRequestMethodGET params:nil mapping:kRestDefaultMapping];
        
        //dispatch_async(dispatch_get_main_queue(), completion);    
    });
}




@end
