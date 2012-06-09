//
//  ExproRole.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExproRole : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *member;
@property (nonatomic, retain) NSSet *routeTable;
@end

@interface ExproRole (CoreDataGeneratedAccessors)

- (void)addMemberObject:(NSManagedObject *)value;
- (void)removeMemberObject:(NSManagedObject *)value;
- (void)addMember:(NSSet *)values;
- (void)removeMember:(NSSet *)values;

- (void)addRouteTableObject:(NSManagedObject *)value;
- (void)removeRouteTableObject:(NSManagedObject *)value;
- (void)addRouteTable:(NSSet *)values;
- (void)removeRouteTable:(NSSet *)values;

@end
