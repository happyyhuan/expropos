//
//  ExproStore.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproMerchant, ExproWarehouse;

@interface ExproStore : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * district_code;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * inventar_num;
@property (nonatomic, retain) NSString * map_info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notice;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * transit_info;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) ExproMerchant *merchant;
@property (nonatomic, retain) ExproWarehouse *warehose;

@end
