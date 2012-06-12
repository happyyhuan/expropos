//
//  ExproGoods.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproDealItem, ExproGoodsType, ExproMerchant, ExproWarehouseWarrantItem;

@interface ExproGoods : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) ExproGoodsType *type;
@property (nonatomic, retain) ExproDealItem *dealItems;
@property (nonatomic, retain) ExproWarehouseWarrantItem *warrantItems;
@property (nonatomic, retain) NSSet *merchants;
@end

@interface ExproGoods (CoreDataGeneratedAccessors)

- (void)addMerchantsObject:(ExproMerchant *)value;
- (void)removeMerchantsObject:(ExproMerchant *)value;
- (void)addMerchants:(NSSet *)values;
- (void)removeMerchants:(NSSet *)values;

@end
