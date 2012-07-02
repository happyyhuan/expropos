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
@end
