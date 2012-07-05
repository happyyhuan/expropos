//
//  ExproRoute.h
//  expropos
//
//  Created by ep3 on 12-7-4.
//  Copyright (c) 2012年 expro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproRole;

@interface ExproRoute : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NSString * module;
@property (nonatomic, retain) NSString * pathname;
@property (nonatomic, retain) NSSet *role;
@end

@interface ExproRoute (CoreDataGeneratedAccessors)

- (void)addRoleObject:(ExproRole *)value;
- (void)removeRoleObject:(ExproRole *)value;
- (void)addRole:(NSSet *)values;
- (void)removeRole:(NSSet *)values;

@end
