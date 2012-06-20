//
//  ExproDealUploader.m
//  expropos
//
//  Created by 昊 曹 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproDealUploader.h"
#import "ExproDeal.h"

@implementation ExproDealUploader

- (id)init {
    self = [super init];
    if (self) {
        [self addCode:201 info:@"上传成功" alert:NO succeed:YES];
        [self addCode:401 info:@"身份验证失败" alert:YES succeed:NO];
    }
    return self;
}

- (void)upload:(ExproDeal *)aDeal {
    if (aDeal) {
        [self requestURL:@"/deals" method:RKRequestMethodPOST object:aDeal mapping:nil serialMapping:nil];
    }
    else {
        [self cancel];
    }
}

@end
