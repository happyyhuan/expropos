//
//  ExproSignHistory.h
//  expropos
//
//  Created by chen on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproUser;

@interface ExproSignHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSDate * signintime;
@property (nonatomic, retain) NSString * orgId;
@property (nonatomic, retain) ExproUser *user;

@end
