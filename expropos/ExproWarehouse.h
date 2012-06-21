//
//  ExproWarehouse.h
//  expropos
//
//  Created by ep3 on 12-6-21.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproStore, ExproWarehouseWarrant;

@interface ExproWarehouse : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *stockIn;
@property (nonatomic, retain) NSSet *stockOut;
@property (nonatomic, retain) ExproStore *store;
@end

@interface ExproWarehouse (CoreDataGeneratedAccessors)

- (void)addStockInObject:(ExproWarehouseWarrant *)value;
- (void)removeStockInObject:(ExproWarehouseWarrant *)value;
- (void)addStockIn:(NSSet *)values;
- (void)removeStockIn:(NSSet *)values;

- (void)addStockOutObject:(ExproWarehouseWarrant *)value;
- (void)removeStockOutObject:(ExproWarehouseWarrant *)value;
- (void)addStockOut:(NSSet *)values;
- (void)removeStockOut:(NSSet *)values;

@end
