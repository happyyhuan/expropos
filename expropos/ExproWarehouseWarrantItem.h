//
//  ExproWarehouseWarrantItem.h
//  expropos
//
//  Created by ep3 on 12-7-5.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoods, ExproWarehouseWarrant;

@interface ExproWarehouseWarrantItem : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) NSNumber * unitCost;
@property (nonatomic, retain) NSNumber * goodsID;
@property (nonatomic, retain) ExproGoods *goods;
@property (nonatomic, retain) ExproWarehouseWarrant *warrant;

@end
