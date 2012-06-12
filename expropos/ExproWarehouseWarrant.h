//
//  ExproWarehouseWarrant.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproMember, ExproWarehouse, ExproWarehouseWarrantItem;

@interface ExproWarehouseWarrant : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) ExproWarehouse *recipient;
@property (nonatomic, retain) ExproMember *operator;
@property (nonatomic, retain) ExproWarehouse *source;
@property (nonatomic, retain) NSSet *items;
@end

@interface ExproWarehouseWarrant (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ExproWarehouseWarrantItem *)value;
- (void)removeItemsObject:(ExproWarehouseWarrantItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
