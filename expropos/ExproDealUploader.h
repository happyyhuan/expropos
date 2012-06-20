//
//  ExproDealUploader.h
//  expropos
//
//  Created by 昊 曹 on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproRestDelegate.h"

#ifndef ExproDealUploadSucceed
#define ExproDealUploadSucceed @"ExproDealUploadSucceed"
#define ExproDealUploadFailed @"ExproDealUploadFailed"
#define ExproDealUploadCanceled @"ExproDealUploadCanceled"
#endif

@class ExproDeal;
@interface ExproDealUploader : ExproRestDelegate
- (void)upload:(ExproDeal *)aDeal;
@end
