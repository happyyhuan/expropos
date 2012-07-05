//
//  ExproDealItem.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproGoods;

@interface ExproDealItem : NSManagedObject

@property (nonatomic, retain) NSNumber * closingCost;
@property (nonatomic, retain) NSNumber * dealID;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * goodsID;
@property (nonatomic, retain) NSNumber * lid;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) ExproDeal *deal;
@property (nonatomic, retain) ExproGoods *goods;

@end
