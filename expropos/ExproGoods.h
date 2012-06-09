//
//  ExproGoods.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproGoodsType;

@interface ExproGoods : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) ExproGoodsType *type;

@end
