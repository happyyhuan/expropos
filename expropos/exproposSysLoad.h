//
//  exproposSysLoad.h
//  expropos
//
//  Created by chen on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExproRestDelegate.h"

@interface exproposSysLoad : ExproRestDelegate

- (void) loadSysData:(NSString*)urlString     
          completion:(void (^)(void))completion; 
@end
