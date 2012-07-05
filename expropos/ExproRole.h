//
//  ExproRole.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproMember, ExproRoute;

@interface ExproRole : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) NSSet *routes;
@end

@interface ExproRole (CoreDataGeneratedAccessors)

- (void)addMembersObject:(ExproMember *)value;
- (void)removeMembersObject:(ExproMember *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

- (void)addRoutesObject:(ExproRoute *)value;
- (void)removeRoutesObject:(ExproRoute *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;

@end
