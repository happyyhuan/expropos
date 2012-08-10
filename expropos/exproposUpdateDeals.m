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

-(void)dealQueryByDealID:(NSString *)dealID
{
    NSString *url = [NSString stringWithFormat:@"/deal/%i",dealID.intValue];
    [self requestURL:url method:RKRequestMethodGET params:nil mapping:nil];
}


-(void)queryDealAmountByCutomerID:(NSNumber  *)customer_id type:(NSNumber *)type beginTime:(NSDate*)bt endTime:(NSDate*)et
{
    self.acceptParallelResults = NO;
    NSString  *url = [NSString stringWithFormat:@"/deal/count?bt=%@&et=%@&customer_id=%i&type=%i",[self dateToString:bt ],[self dateToString:et],customer_id.intValue,type.intValue];
    RKObjectMapping *callBackMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [callBackMapping mapKeyPath:@"count" toAttribute:@"count"];
    [self requestURL:url method:RKRequestMethodGET params:nil  mapping:callBackMapping];
}

-(NSString *)dateToString:(NSDate*)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}


-(void)queryDealByCustomerID:(NSNumber *)customer_id start:(int)start limit:(int)limit type:(int)type bt:(NSDate*)bt et:(NSDate *)et
{
    self.acceptParallelResults = YES;
    NSString  *url = [NSString stringWithFormat:@"/deals?bt=%@&et=%@&customer_id=%i&type=%i&start=%i&limit=%i&sidx=create_time&sord=desc",[self dateToString:bt ],[self dateToString:et],customer_id.intValue,type,start,limit];
      [self requestURL:url method:RKRequestMethodGET params:nil  mapping:nil];
}
@end
