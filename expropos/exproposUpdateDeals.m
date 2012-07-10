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
       
    }
    return self;
}



-(void)upDateDealStart:(int)start end:(int)end bt:(NSDate*)bt et:(NSDate*)et
{
 //start=起始行数&limit=每页显示行数&bt=交易发生时间起点&et=交易发生时间的截至时间&sidx=排序字段名&sord=排序方式asc,desc
   /* NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt: start] ,@"start",[NSNumber numberWithInt:end],@"limit", nil];
   [self requestURL:@"/deals" method:RKRequestMethodGET params:params mapping:nil];*/
    NSString *url = [NSString stringWithFormat:@"deals?start=%i&limit=%i",start,end];
    [self requestURL:url method:RKRequestMethodGET params:nil mapping:nil];
    
}

-(void)updateDeal
{
    for(ExproDeal *deal in [ExproDeal findAll]){
        NSString *url = [NSString stringWithFormat:@"/deals/%i",deal.gid.intValue];
       [self requestURL:url   method:RKRequestMethodGET object:nil mapping:nil serialMapping:nil];
    }
    
}


@end
