//
//  ExproGoods.h
//  expropos
//
//  Created by ep3 on 12-6-21.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDealItem, ExproGoodsType, ExproMerchant, ExproWarehouseWarrantItem;

@interface ExproGoods : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSSet *dealItems;
@property (nonatomic, retain) NSSet *merchants;
@property (nonatomic, retain) ExproGoodsType *type;
@property (nonatomic, retain) ExproWarehouseWarrantItem *warrantItems;
@end

@interface ExproGoods (CoreDataGeneratedAccessors)

- (void)addDealItemsObject:(ExproDealItem *)value;
- (void)removeDealItemsObject:(ExproDealItem *)value;
- (void)addDealItems:(NSSet *)values;
- (void)removeDealItems:(NSSet *)values;

- (void)addMerchantsObject:(ExproMerchant *)value;
- (void)removeMerchantsObject:(ExproMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

@end
