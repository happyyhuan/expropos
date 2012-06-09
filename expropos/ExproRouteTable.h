//
//  ExproRouteTable.h
//  expropos
//
//  Created by gbo on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExproRole;

@interface ExproRouteTable : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NSString * module;
@property (nonatomic, retain) NSString * route;
@property (nonatomic, retain) ExproRole *role;

@end
