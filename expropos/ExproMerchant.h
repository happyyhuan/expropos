//
//  ExproMerchant.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoods, ExproMember, ExproStore;

@interface ExproMerchant : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * dueTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *goods;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) NSSet *stores;
@end

@interface ExproMerchant (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(ExproGoods *)value;
- (void)removeGoodsObject:(ExproGoods *)value;
- (void)addGoods:(NSSet *)values;
- (void)removeGoods:(NSSet *)values;

- (void)addMembersObject:(ExproMember *)value;
- (void)removeMembersObject:(ExproMember *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

- (void)addStoresObject:(ExproStore *)value;
- (void)removeStoresObject:(ExproStore *)value;
- (void)addStores:(NSSet *)values;
- (void)removeStores:(NSSet *)values;

@end
