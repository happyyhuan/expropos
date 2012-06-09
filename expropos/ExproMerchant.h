//
//  ExproMerchant.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExproMerchant : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * dueTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *goodsType;
@property (nonatomic, retain) NSSet *member;
@end

@interface ExproMerchant (CoreDataGeneratedAccessors)

- (void)addGoodsTypeObject:(NSManagedObject *)value;
- (void)removeGoodsTypeObject:(NSManagedObject *)value;
- (void)addGoodsType:(NSSet *)values;
- (void)removeGoodsType:(NSSet *)values;

- (void)addMemberObject:(NSManagedObject *)value;
- (void)removeMemberObject:(NSManagedObject *)value;
- (void)addMember:(NSSet *)values;
- (void)removeMember:(NSSet *)values;

@end
