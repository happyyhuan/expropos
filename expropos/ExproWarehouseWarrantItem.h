//
//  ExproWarehouseWarrantItem.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoods, ExproWarehouseWarrant;

@interface ExproWarehouseWarrantItem : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSNumber * unitCost;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) ExproWarehouseWarrant *warrant;
@property (nonatomic, retain) ExproGoods *goods;

@end
