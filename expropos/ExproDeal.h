//
//  ExproDeal.h
//  expropos
//
//  Created by 昊 曹 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDealItem, ExproMember;

@interface ExproDeal : NSManagedObject

@property (nonatomic, retain) NSNumber * cash;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * payment;
@property (nonatomic, retain) NSNumber * payType;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) ExproMember *customer;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) ExproMember *operator;
@end

@interface ExproDeal (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ExproDealItem *)value;
- (void)removeItemsObject:(ExproDealItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
