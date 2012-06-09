//
//  ExproUser.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


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
@property (nonatomic, retain) NSSet *member;
@end

@interface ExproUser (CoreDataGeneratedAccessors)

- (void)addMemberObject:(NSManagedObject *)value;
- (void)removeMemberObject:(NSManagedObject *)value;
- (void)addMember:(NSSet *)values;
- (void)removeMember:(NSSet *)values;

@end
