//
//  ExproStaff.h
//  expropos
//
//  Created by chen on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExproStaff : NSManagedObject

@property (nonatomic, retain) NSNumber * memberId;
@property (nonatomic, retain) NSNumber * storeId;

@end
