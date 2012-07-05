//
//  ExproWarehouse.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproStore, ExproWarehouseWarrant;

@interface ExproWarehouse : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ExproStore *store;
@property (nonatomic, retain) ExproWarehouseWarrant *stockIn;
@property (nonatomic, retain) ExproWarehouseWarrant *stockOut;

@end
