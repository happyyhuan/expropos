//
//  ployeeRegistr.h
//  expropos
//
//  Created by chen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExproRestDelegate.h"

@interface ployeeRegistr : ExproRestDelegate


- (void)registr:(NSString *)cellphone name:(NSString *)name petName:(NSString *)petName storeId:(NSString *)storeId
          email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment
            sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSString *)dueTime

          birth:(NSString *)birthDate  memPetName:(NSString *)memPetName role:(NSMutableArray *)roles;

- (void)modify:(NSString *)memId cellPhone:(NSString *)cellphone storeId:(NSString *)storeId petName:(NSString *)petName 
         email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment
         sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSDate *)dueTime
         birth:(NSString *)birthDate  memPetName:(NSString *)memPetName role:(NSMutableArray *)roles;

- (void)delete:(NSString *)memId;
@end
