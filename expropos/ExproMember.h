//
//  ExproMember.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproMerchant, ExproRole, ExproUser, ExproWarehouseWarrant;

@interface ExproMember : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSDate * dueTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * petName;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * privacy;
@property (nonatomic, retain) NSNumber * savings;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) ExproMerchant *org;
@property (nonatomic, retain) ExproRole *role;
@property (nonatomic, retain) ExproUser *user;
@property (nonatomic, retain) NSSet *sales;
@property (nonatomic, retain) ExproDeal *purchases;
@property (nonatomic, retain) ExproWarehouseWarrant *warehouseWarrants;
@end

@interface ExproMember (CoreDataGeneratedAccessors)

- (void)addSalesObject:(ExproDeal *)value;
- (void)removeSalesObject:(ExproDeal *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

@end
