//
//  ExproUser.h
//  expropos
//
//  Created by gbo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproMember;

@interface ExproUser : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * cellphone;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * idcard;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * petName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSSet *members;
@end

@interface ExproUser (CoreDataGeneratedAccessors)

- (void)addMembersObject:(ExproMember *)value;
- (void)removeMembersObject:(ExproMember *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

@end
