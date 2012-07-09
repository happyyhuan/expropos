//
//  exproposDealOperate.h
//  expropos
//
//  Created by haitao chen on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExproRestDelegate.h"
#import "ExproDeal.h"

@interface exproposDealOperate :  ExproRestDelegate 

-(void)createDeal:(ExproDeal *)deal;
@end
