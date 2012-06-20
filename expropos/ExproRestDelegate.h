//
//  ExproRestDelegate.h
//  GSTE
//
//  Created by 昊 曹 on 12-3-3.
//  Copyright (c) 2012年 泛盈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

#ifndef kRestDefaultMapping
#define kRestDefaultMapping nil
#endif

#ifndef ExproRestSucceedWithObject 
#define ExproRestSucceedWithObject @"ExproRestSucceedWithObject"
#define ExproRestSucceedWithoutData @"ExproRestSucceedWithoutData"
#define ExproRestSucceedWithObjects @"ExproRestSucceedWithObjects"
#define ExproRestFailed @"ExproRestFailed"
#define ExproRestCanceled @"ExproRestCanceled"
#endif

@interface ExproHttpCodeOption : NSObject {
    int _statusCode;
    NSString *_info;
    BOOL _alert;
    BOOL _succeed;
}
@property (nonatomic) int statusCode;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, getter = shouldAlert) BOOL alert;
@property (nonatomic, getter = isSucceed) BOOL succeed;
@end

@interface ExproRestDelegate : NSObject<RKObjectLoaderDelegate> {
    NSMutableArray *_codeOptions;
    BOOL _alert;
    NSString *_timeOutWarning;
    NSString *_unknownErrorWarning;
    NSString *_noServerWarning;
    BOOL _acceptParallelResults;
}

@property (nonatomic, getter = shouldAlert) BOOL alert;
@property (nonatomic,readonly) BOOL acceptParallelResults;
@property (nonatomic, copy) NSString *errorTitle;
@property (nonatomic, copy) NSString *succeedTitle;
@property (nonatomic, copy) NSString *ok;
@property (nonatomic, weak) NSString *cookie;

- (void)addCode:(int)aCode info:(NSString *)aInfo alert:(BOOL)alert succeed:(BOOL)succeed;
- (void)removeCode:(int)aCode;
- (void)requestURL:(NSString *)aURL
            method:(RKRequestMethod)aMethod
            params:(NSDictionary *)params
           mapping:(RKObjectMapping *)aMapping;
- (void)requestURL:(NSString *)aURL
            method:(RKRequestMethod)aMethod 
            object:(id)aObject
           mapping:(RKObjectMapping *)aMapping
     serialMapping:(RKObjectMapping *)aSerialMapping;
- (void)cancel;
- (void)succeed:(id)object;
- (void)succeed4Parallel:(NSArray *)array;
- (void)succeedWithoutData;
- (void)failed:(NSError *)error;
- (void)canceled;
@end
