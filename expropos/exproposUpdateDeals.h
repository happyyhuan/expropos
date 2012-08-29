//
//  exproposUpdateDeals.h
//  expropos
//
//  Created by haitao chen on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"
#import "ExproDeal.h"
#import "ExproRestDelegate.h"

/*
 start=起始的集合位置&end=结束的集合位置&bt=交易发生时间起点&et=交易发生时间的截至时间
 */
@interface exproposUpdateDeals :ExproRestDelegate

-(void)upDateDealStart:(int)start end:(int)end bt:(NSDate*)bt et:(NSDate*)et;
-(void)updateDeal;
-(void)dealQueryByDealID:(NSString *)dealID;
//bt=时间起点&et=截至时间&customer_id=23&type=2
-(void)queryDealAmountByCutomerID:(NSNumber  *)customer_id type:(NSNumber *)type beginTime:(NSDate*)bt endTime:(NSDate*)et;
-(void)queryDealByCustomerID:(NSNumber *)customer_id start:(int)start limit:(int)limit type:(int)type bt:(NSDate*)bt et:(NSDate *)et;
-(void)queryDealsStart:(int)start limit:(int)limit bt:(NSDate*)bt et:(NSDate*)et memberIds:(NSArray *)ids types:(NSArray*)types payTypes:(NSArray*)payTyes storeIds:(NSArray *)storeIds minAmount:(double)min maxAmount:(double)max;
-(void)queyDealCountsStart:(int)start limit:(int)limit bt:(NSDate*)bt et:(NSDate*)et memberIds:(NSArray *)ids types:(NSArray*)types payTypes:(NSArray*)payTyes storeIds:(NSArray *)storeIds minAmount:(double)min maxAmount:(double)max;
@end
