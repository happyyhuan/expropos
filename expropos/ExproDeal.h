//
//  ExproDeal.h
//  expropos
//
//  Created by haitao chen on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproDealItem, ExproMember, ExproStore;

@interface ExproDeal : NSManagedObject

@property (nonatomic, retain) NSNumber * cash;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * customerID;
@property (nonatomic, retain) NSNumber * dealerID;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * lid;
@property (nonatomic, retain) NSNumber * payment;
@property (nonatomic, retain) NSNumber * payType;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * repealID;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * storeID;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) ExproMember *customer;
@property (nonatomic, retain) ExproMember *dealer;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) ExproDeal *repeal;
@property (nonatomic, retain) ExproStore *store;
@end

@interface ExproDeal (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ExproDealItem *)value;
- (void)removeItemsObject:(ExproDealItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
