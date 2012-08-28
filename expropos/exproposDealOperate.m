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
        [self addCode:403 info:NSLocalizedString(@"无权限进入", nil) alert:NO succeed:NO];
        [self addCode:502 info:NSLocalizedString(@"server error", nil) alert:NO succeed:NO];
        
        self.succeedTitle = NSLocalizedString(@"CreateSucceed", nil);
        self.errorTitle = NSLocalizedString(@"CreateFailed", nil);
    }
    return self;
}


-(void)createDeal:(ExproDeal *)deal
{
   
    
    RKObjectMapping *callbackMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [callbackMapping mapKeyPathsToAttributes:@"_id", @"gid",  nil];
       
    self.acceptParallelResults = NO;
    [self requestURL:@"/deal" method:RKRequestMethodPOST object:deal
             mapping:callbackMapping 
            serialMapping:[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[ExproDeal class]]];
    
    
}
-(void)createAddmemberSavingDeal:(NSDictionary *)dic
{
    
    
    RKObjectMapping *callbackMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [callbackMapping mapKeyPathsToAttributes:@"_id", @"gid",  nil];
    
    self.acceptParallelResults = NO;

    [self requestURL:@"/deal" method:RKRequestMethodPOST params:dic mapping:callbackMapping];
    
}

-(void)createGoodsComeBackDeal:(ExproDeal *)deal
{
    
    RKObjectMapping *callbackMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [callbackMapping mapKeyPathsToAttributes:@"_id", @"gid",  nil];
    
    self.acceptParallelResults = NO;
    [self requestURL:@"/deal/repeal" method:RKRequestMethodPOST object:deal
             mapping:callbackMapping 
       serialMapping:[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[ExproDeal class]]];
}

@end
