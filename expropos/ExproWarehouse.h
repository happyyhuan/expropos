//
//  ExproWarehouse.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproStore, ExproWarehouseWarrant;

@interface ExproWarehouse : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ExproStore *store;
@property (nonatomic, retain) NSSet *stockIn;
@property (nonatomic, retain) NSSet *stockOut;
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
