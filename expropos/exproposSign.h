//
//  exproposSign.h
//  expropos
//
//  Created by gbo on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExproRestDelegate.h"

@interface exproposSign : ExproRestDelegate
@property (nonatomic) NSInteger statusCode;
- (void) signin:(NSString *)cellphone password:(NSString *)password;
@end
