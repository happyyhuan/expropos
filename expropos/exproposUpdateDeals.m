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
         [self addCode:400 info:NSLocalizedString(@"not found", nil) alert:NO succeed:NO];
         [self addCode:502 info:NSLocalizedString(@"server error", nil) alert:NO succeed:NO];
        
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

-(void)queryDealsStart:(int)start limit:(int)limit bt:(NSDate*)bt et:(NSDate*)et memberIds:(NSArray *)memberIds types:(NSArray*)types payTypes:(NSArray*)payTyes storeIds:(NSArray *)storeIds minAmount:(double)min maxAmount:(double)max
{
    /*
     /deals?qy_customer_ids=159,23,155,24,25&qy_store_ids=111,112,13&qy_type=1&qy_pay_type=3&qy_payment_min=10&qy_payment_max=500
     */
     NSMutableString *url = [NSMutableString stringWithFormat:@"/deals?start=%i&limit=%i",start,limit];
    if(bt){
        [url appendFormat:@"&bt=%@",[self dateToString:bt]];
    }
    if(et){
        [url appendFormat:@"&et=%@",[self dateToString:et]];
    }
    if(memberIds.count>0){
        [url appendFormat:@"&qy_customer_ids="];
        for(NSNumber *idx in memberIds){
            [url appendFormat:@"%i,",idx.intValue];
        }
    }
    if(types.count>0){
        [url appendFormat:@"&qy_type="];
        for(NSNumber *idx in types){
            [url appendFormat:@"%i,",idx.intValue];
        }
    }
    if(payTyes.count>0){
        [url appendFormat:@"&qy_pay_type="];
        for(NSNumber *idx in payTyes){
            [url appendFormat:@"%i,",idx.intValue];
        }
    }
    if(storeIds.count>0){
        [url appendFormat:@"&qy_store_ids="];
        for(NSNumber *idx in storeIds){
            [url appendFormat:@"%i,",idx.intValue];
        }
    }
    if(min>0){
        [url appendFormat:@"&qy_payment_min=%g",min];
    }
    if(max>0){
        [url appendFormat:@"&qy_payment_max=%g",max];
    }
    self.acceptParallelResults = YES;
    [self requestURL:url method:RKRequestMethodGET params:nil mapping:nil];
    
}

-(void)queyDealCountsStart:(int)start limit:(int)limit bt:(NSDate*)bt et:(NSDate*)et memberIds:(NSArray *)memberIds types:(NSArray*)types payTypes:(NSArray*)payTyes storeIds:(NSArray *)storeIds minAmount:(double)min maxAmount:(double)max
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"/deal/count?start=%i&limit=%i",start,limit];
    if(bt){
        [url appendFormat:@"&bt=%@",[self dateToString:bt]];
    }
    if(et){
        [url appendFormat:@"&et=%@",[self dateToString:et]];
    }
    if(memberIds.count>0){
        [url appendFormat:@"&qy_customer_ids="];
        for(NSNumber *idx in memberIds){
            [url appendFormat:@"%i,",idx.intValue];
        }
        NSRange range = NSMakeRange (url.length-1, 1);
        [url deleteCharactersInRange:range];
    
    }
    if(types.count>0){
        [url appendFormat:@"&qy_type="];
        for(NSNumber *idx in types){
            [url appendFormat:@"%i,",idx.intValue];
        }
        NSRange range = NSMakeRange (url.length-1, 1);
        [url deleteCharactersInRange:range];
    }
    if(payTyes.count>0){
        [url appendFormat:@"&qy_pay_type="];
        for(NSNumber *idx in payTyes){
            [url appendFormat:@"%i,",idx.intValue];
        }
        NSRange range = NSMakeRange (url.length-1, 1);
        [url deleteCharactersInRange:range];
    }
    if(storeIds.count>0){
        [url appendFormat:@"&qy_store_ids="];
        for(NSNumber *idx in storeIds){
            [url appendFormat:@"%i,",idx.intValue];
        }
        NSRange range = NSMakeRange (url.length-1, 1);
        [url deleteCharactersInRange:range];
    }
    if(min>0){
        [url appendFormat:@"&qy_payment_min=%g",min];
    }
    if(max>0){
        [url appendFormat:@"&qy_payment_max=%g",max];
    }
    RKObjectMapping *callbackMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [callbackMapping mapKeyPath:@"count" toAttribute:@"count"];
    [self requestURL:url method:RKRequestMethodGET params:nil mapping:callbackMapping];
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
    NSString *url = [NSString stringWithFormat:@"/deal/%@",dealID];
    [self requestURL:url method:RKRequestMethodGET params:nil mapping:nil];
}


-(void)queryDealAmountByCutomerID:(NSNumber  *)customer_id type:(NSNumber *)type beginTime:(NSDate*)bt endTime:(NSDate*)et
{
    NSTimeInterval timeInterval = 24*60*60;
    et = [NSDate dateWithTimeInterval:timeInterval sinceDate:et];
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
    NSTimeInterval timeInterval = 24*60*60;
    et = [NSDate dateWithTimeInterval:timeInterval sinceDate:et];
    self.acceptParallelResults = YES;
    NSString  *url = [NSString stringWithFormat:@"/deals?bt=%@&et=%@&customer_id=%i&type=%i&start=%i&limit=%i&sidx=create_time&sord=desc",[self dateToString:bt ],[self dateToString:et],customer_id.intValue,type,start,limit];
      [self requestURL:url method:RKRequestMethodGET params:nil  mapping:nil];
}
@end
