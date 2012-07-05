//
//  exproposSyncModel.m
//  expropos
//
//  Created by ep3 on 12-7-2.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import "exproposSyncModel.h"
#import "ExproRole.h"
#import "ExproRoute.h"
#import "ExproGoodsType.h"
#import "ExproMerchant.h"
#import "ExproStore.h"
#import "ExproMember.h"
#import "ExproUser.h"
#import "ExproGoods.h"

@implementation exproposSyncModel

- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"LoginSucceed", nil) alert:NO succeed:YES];
        [self addCode:401 info:NSLocalizedString(@"IncorrectPassword", nil) alert:YES succeed:NO];
        [self addCode:403 info:NSLocalizedString(@"ForbidUser", nil) alert:YES succeed:NO];
        [self addCode:404 info:NSLocalizedString(@"NoSuchUser", nil) alert:NO succeed:NO];
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);
//        self.reserver = self;
    }
    return self;
}

- (void) printSelf:(ExproRoute *)route {
    NSLog(@"route==%@", route);
}
- (void) succeed:(id)object {
    [super succeed:object];
    ExproRole * role = (ExproRole *)object;
    ExproRoute *route = (ExproRoute *)[role.routes anyObject];
    NSLog(@"gbo==%@", route);
}

- (void) succeed4Parallel:(NSArray *)array {
    [super succeed4Parallel:array];
    NSLog(@"array count = %d", array.count);
    for (NSObject * object in array) {
        if ([object isKindOfClass:[ExproRole class]]) {
            ExproRole *role = (ExproRole *)object;
            for(ExproRoute * route in role.routes) {
                NSLog(@"Role:%@=%@", role.name, route.pathname);
            }
        }
        if ([object isKindOfClass:[ExproGoodsType class]]) {
            ExproGoodsType *gt = (ExproGoodsType *)object;
            NSLog(@"%@", gt.name);
            for(ExproGoodsType * leaf in gt.leaves) {
                NSLog(@"Goods Type:%@=%@", gt.name, leaf.name);
            }
        }
        if ([object isKindOfClass:[ExproMerchant class]]) {
            ExproMerchant *gt = (ExproMerchant *)object;
            NSLog(@"%@", gt.shortName);
            for(ExproStore * store in gt.stores) {
                NSLog(@"Merchant Store:%@=%@", gt.shortName, store.name);
                for (ExproMember * staff in store.staffs) {
                    NSLog(@"====Store:%@, %@", store.name, staff.user.name);
                    for (ExproRoute * route in staff.role.routes) {
                        NSLog(@"========route:%@", route.pathname);
                    }
                }
            }
            for(ExproGoods * g in gt.goods) {
                NSLog(@"*=*=Merchant Goods:%@, type:%@", g.name, g.type.name);
            }
        }
    }
}

- (void) syncMerchant 
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *syncURL = [NSString stringWithFormat:@"/sync/merchants/%u",[userDefault integerForKey:@"merchantID"]];
    
    self.acceptParallelResults = YES;
    
    [self requestURL:syncURL method:RKRequestMethodGET params:nil mapping:nil];
}

- (void) syncStore:(NSNumber *)gid
{
    NSString *syncURL = [NSString stringWithFormat:@"/sync/stores/%qu",gid.unsignedLongLongValue];
    
    [self requestURL:syncURL method:RKRequestMethodGET params:nil mapping:nil];
}
@end
