//
//  ExproMember.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproMerchant, ExproRole, ExproStore, ExproUser, ExproWarehouseWarrant;

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
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * orgID;
@property (nonatomic, retain) NSNumber * roleID;
@property (nonatomic, retain) ExproMerchant *org;
@property (nonatomic, retain) NSSet *purchases;
@property (nonatomic, retain) ExproRole *role;
@property (nonatomic, retain) NSSet *sales;
@property (nonatomic, retain) ExproStore *store;
@property (nonatomic, retain) ExproUser *user;
@property (nonatomic, retain) NSSet *warehouseWarrants;
@end

@interface ExproMember (CoreDataGeneratedAccessors)

- (void)addPurchasesObject:(ExproDeal *)value;
- (void)removePurchasesObject:(ExproDeal *)value;
- (void)addPurchases:(NSSet *)values;
- (void)removePurchases:(NSSet *)values;

- (void)addSalesObject:(ExproDeal *)value;
- (void)removeSalesObject:(ExproDeal *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

- (void)addWarehouseWarrantsObject:(ExproWarehouseWarrant *)value;
- (void)removeWarehouseWarrantsObject:(ExproWarehouseWarrant *)value;
- (void)addWarehouseWarrants:(NSSet *)values;
- (void)removeWarehouseWarrants:(NSSet *)values;

@end
