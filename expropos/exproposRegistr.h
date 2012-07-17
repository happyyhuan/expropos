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

          birth:(NSString *)birthDate  level:(NSNumber *)level;
@end
