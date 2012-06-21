//
//  ExproRouteTable.h
//  expropos
//
//  Created by ep3 on 12-6-21.
//  Copyright (c) 2012年 expro. All rights reserved.
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
