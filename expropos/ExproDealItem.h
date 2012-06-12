//
//  ExproDealItem.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproGoods;

@interface ExproDealItem : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSNumber * closingCost;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) ExproDeal *deal;
@property (nonatomic, retain) ExproGoods *goods;

@end
