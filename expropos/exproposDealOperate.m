//
//  exproposDealOperate.m
//  expropos
//
//  Created by haitao chen on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposDealOperate.h"

@implementation exproposDealOperate
- (id)init {
    self = [super init];
    if (self) {
        [self addCode:201 info:NSLocalizedString(@"CreateSucceed", nil) alert:NO succeed:YES];
        [self addCode:401 info:NSLocalizedString(@"UnAuthoried", nil) alert:YES succeed:NO];
        [self addCode:400 info:NSLocalizedString(@"bad request", nil) alert:YES succeed:NO];
      
        self.succeedTitle = NSLocalizedString(@"CreateSucceed", nil);
        self.errorTitle = NSLocalizedString(@"CreateFailed", nil);
    }
    return self;
}


-(void)createDeal:(ExproDeal *)deal
{
   // {"deal":{"lid":123, "_id":322, "deal_item":[{"lid":234, "_id":23,"dealer_id":34}]}}
    
    RKObjectMapping *getDealMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [getDealMapping mapKeyPathsToAttributes:@"_id", @"gid", nil];
    [getDealMapping mapAttributes:@"lid", nil];
    
    RKObjectMapping *getDealItemmapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [getDealItemmapping mapKeyPathsToAttributes:@"_id",@"gid",@"dealer_id",@"dealerID",nil];
    [getDealItemmapping mapAttributes:@"lid", nil];
    //[[RKObjectManager sharedManager].mappingProvider setMapping:getDealItemmapping forKeyPath:@"deal_item"];
    [getDealMapping mapRelationship:@"deal_item" withMapping:getDealItemmapping];
    
    
   //  [[RKObjectManager sharedManager].mappingProvider setMapping:getDealMapping forKeyPath:@"deal"];
        
    [self requestURL:@"/deals" method:RKRequestMethodPOST object:deal
             mapping:getDealMapping
            serialMapping:[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[ExproDeal class]]];
    
}


@end
