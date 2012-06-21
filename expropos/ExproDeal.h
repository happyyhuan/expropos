//
//  ExproDeal.h
//  expropos
//
//  Created by ep3 on 12-6-21.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDealItem, ExproMember, ExproStore;

@interface ExproDeal : NSManagedObject

@property (nonatomic, retain) NSNumber * cash;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * payment;
@property (nonatomic, retain) NSNumber * payType;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * lid;
@property (nonatomic, retain) ExproMember *customer;
@property (nonatomic, retain) ExproMember *dealer;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) ExproStore *store;
@end

@interface ExproDeal (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ExproDealItem *)value;
- (void)removeItemsObject:(ExproDealItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
