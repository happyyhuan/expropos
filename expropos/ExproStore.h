//
//  ExproStore.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDeal, ExproMember, ExproMerchant, ExproWarehouse;

@interface ExproStore : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * districtCode;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * inventarNum;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * mapInfo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notice;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * transitInfo;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) ExproMerchant *merchant;
@property (nonatomic, retain) NSSet *staffs;
@property (nonatomic, retain) ExproWarehouse *warehose;
@end

@interface ExproStore (CoreDataGeneratedAccessors)

- (void)addDealsObject:(ExproDeal *)value;
- (void)removeDealsObject:(ExproDeal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addStaffsObject:(ExproMember *)value;
- (void)removeStaffsObject:(ExproMember *)value;
- (void)addStaffs:(NSSet *)values;
- (void)removeStaffs:(NSSet *)values;

@end
