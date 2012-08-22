//
//  exproposStoreEdit.h
//  expropos
//
//  Created by chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproRestDelegate.h"

@interface exproposStoreEdit : ExproRestDelegate
@property (nonatomic) NSInteger *statusCode;
-(void)storeAdd:(NSString *)storeName merchant:(NSString *)merchant_id  state:(NSString *)state inventar:(NSString *)inventar_num district:(NSString *) district_code address:(NSString *)address transit:(NSString *)transit_info  map:(NSString *)map_info
         notice:(NSString *)notice  comment:(NSString *)comment; 

-(void)storeEdit:(NSString *)storeName merchant:(NSString *)merchant_id  state:(NSString *)state inventar:(NSString *)inventar_num district:(NSString *) district_code address:(NSString *)address transit:(NSString *)transit_info  map:(NSString *)map_info
          notice:(NSString *)notice  comment:(NSString *)comment storeId:(NSString *)storeId; 
-(void)storeDelete:(NSInteger *)storeId;
@end
