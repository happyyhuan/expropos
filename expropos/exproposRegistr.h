//
//  exproposRegistr.h
//  expropos
//
//  Created by chen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExproRestDelegate.h"

@interface exproposRegistr : ExproRestDelegate



- (void)registr:(NSString *)cellphone name:(NSString *)name petName:(NSString *)petName 
          email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment
            sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSString *)dueTime

          birth:(NSString *)birthDate  memPetName:(NSString *)memPetName;

- (void)modify:(NSString *)memId cellPhone:(NSString *)cellphone name:(NSString *)name petName:(NSString *)petName 
         email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment
           sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSDate *)dueTime

         birth:(NSString *)birthDate  memPetName:(NSString *)memPetName;

- (void)delete:(NSInteger)memId;
@end
