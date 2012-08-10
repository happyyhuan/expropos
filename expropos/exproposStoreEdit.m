//
//  exproposStoreEdit.m
//  expropos
//
//  Created by chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposStoreEdit.h"

@implementation exproposStoreEdit

@synthesize statusCode=_statusCode;

- (id)init {
    self = [super init];
    if (self) {
        [self addCode:200 info:NSLocalizedString(@"删除成功", nil) alert:NO succeed:YES];
        [self addCode:201 info:NSLocalizedString(@"createSucceed", nil) alert:NO succeed:YES];
        [self addCode:403 info:NSLocalizedString(@"ForbidUser", nil) alert:YES succeed:NO];
        
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);
        self.reserver = self;
    }
    return self;
}
- (void)alert:(NSString *)aTitle warning:(NSString *)aWarning {
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:aTitle
                                                         message:aWarning
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [_alertView show];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    
    if (response.statusCode == 201)
    {
        self.statusCode = response.statusCode;
        self.errorTitle = NSLocalizedString(@"Warning", nil);
//        [self alert:self.errorTitle warning:NSLocalizedString(@"用户名或密码输入错误", nil)];
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"OK"
                                                             message:@"OK"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [_alertView show];
    }
}

-(void)storeAdd:(NSString *)storeName merchant:(NSString *)merchant_id warehouse_name:(NSString *)warehouse_name state:(NSString *)state inventar:(NSString *)inventar_num district:(NSString *) district_code address:(NSString *)address transit:(NSString *)transit_info  map:(NSString *)map_info
    notice:(NSString *)notice  comment:(NSString *)comment 
{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"merchant_id",
                            storeName, @"name", @"1", @"state",
                            @"0123abc", @"inventar_num", @"086-025-2211100", @"district_code",
                           address, @"address", transit_info, @"transit_info",map_info, @"map_info",
                           notice, @"notice", comment, @"comment", nil];   
    [self requestURL:@"/store" method:RKRequestMethodPOST params:params mapping:nil];
    
}

-(void)storeEdit:(NSString *)storeName merchant:(NSString *)merchant_id warehouse_name:(NSString *)warehouse_name state:(NSString *)state inventar:(NSString *)inventar_num district:(NSString *) district_code address:(NSString *)address transit:(NSString *)transit_info  map:(NSString *)map_info
          notice:(NSString *)notice  comment:(NSString *)comment storeId:(NSNumber *)storeId
{          
   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                           storeId.stringValue,@"_id",
                           @"1", @"merchant_id",
                           storeName, @"name",state, @"state",
                           @"0123abc", @"inventar_num", @"086-025-2211100", @"district_code",
                           address, @"address",transit_info, @"transit_info",@"3333", @"map_info",
                           notice, @"notice", comment, @"comment", nil];     
    
    NSString *url = [NSString stringWithFormat:@"/store?_id=%i",storeId];
    [self requestURL:url method:RKRequestMethodPUT params:params mapping:nil];
}

-(void)storeDelete:(NSInteger *)storeId
{
    NSString *url = [NSString stringWithFormat:@"/store/%i",storeId];
    [self requestURL:url method:RKRequestMethodDELETE params:nil mapping:nil];
}
@end