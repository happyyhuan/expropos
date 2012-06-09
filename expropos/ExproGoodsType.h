//
//  ExproGoodsType.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoodsType, ExproMerchant, Goods;

@interface ExproGoodsType : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * isleaf;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSSet *goods;
@property (nonatomic, retain) NSSet *leaves;
@property (nonatomic, retain) NSSet *merchant;
@property (nonatomic, retain) ExproGoodsType *parent;
@end

@interface ExproGoodsType (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(Goods *)value;
- (void)removeGoodsObject:(Goods *)value;
- (void)addGoods:(NSSet *)values;
- (void)removeGoods:(NSSet *)values;

- (void)addLeavesObject:(ExproGoodsType *)value;
- (void)removeLeavesObject:(ExproGoodsType *)value;
- (void)addLeaves:(NSSet *)values;
- (void)removeLeaves:(NSSet *)values;

- (void)addMerchantObject:(ExproMerchant *)value;
- (void)removeMerchantObject:(ExproMerchant *)value;
- (void)addMerchant:(NSSet *)values;
- (void)removeMerchant:(NSSet *)values;

@end
