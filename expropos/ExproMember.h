//
//  ExproMember.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproMerchant, ExproRole, ExproUser;

@interface ExproMember : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSDate * dueTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * petName;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * privacy;
@property (nonatomic, retain) NSNumber * savings;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) ExproMerchant *org;
@property (nonatomic, retain) ExproRole *role;
@property (nonatomic, retain) ExproUser *user;

@end
