//
//  ExproGoodsType.h
//  expropos
//
//  Created by 昊 曹 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoods, ExproGoodsType;

@interface ExproGoodsType : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * isleaf;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *goods;
@property (nonatomic, retain) NSSet *leaves;
@property (nonatomic, retain) ExproGoodsType *parent;
@end

@interface ExproGoodsType (CoreDataGeneratedAccessors)

- (void)addGoodsObject:(ExproGoods *)value;
- (void)removeGoodsObject:(ExproGoods *)value;
- (void)addGoods:(NSSet *)values;
- (void)removeGoods:(NSSet *)values;

- (void)addLeavesObject:(ExproGoodsType *)value;
- (void)removeLeavesObject:(ExproGoodsType *)value;
- (void)addLeaves:(NSSet *)values;
- (void)removeLeaves:(NSSet *)values;

@end
