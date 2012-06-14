//
//  ExproRestDelegate.m
//  GSTE
//
//  Created by 昊 曹 on 12-3-3.
//  Copyright (c) 2012年 泛盈. All rights reserved.
//

#import "ExproRestDelegate.h"
//#import "AppDelegate.h"

@implementation ExproHttpCodeOption

@synthesize statusCode = _statusCode;
@synthesize info = _info;
@synthesize alert = _alert;
@synthesize succeed = _succeed;
- (void)dealloc {
    self.info = nil;
}
@end

@interface ExproRestDelegate (Internal) 
- (ExproHttpCodeOption *)code4:(int)aCode;
- (void)alert:(NSString *)aTitle warning:(NSString *)aWarning;

@end

@implementation ExproRestDelegate 
@synthesize reserver = _reserver;
@synthesize succeedCallBack = _succeedCallBack;
@synthesize failedCallBack = _failedCallBack;
@synthesize cancelCallBack = _cancelCallBack;
@synthesize alert = _alert;
@synthesize errorTitle = _errorTitle;
@synthesize succeedTitle = _succeedTitle;
@synthesize ok = _ok;
@synthesize acceptParallelResults = _acceptParallelResults;

- (id)init {
    self = [super init];
    if (self) {
        self.alert = YES;
        self.acceptParallelResults = NO;
        _codeOptions = [NSMutableArray new];
        _timeOutWarning = NSLocalizedString(@"TimeOut", nil);
        _unknownErrorWarning = NSLocalizedString(@"UnknownError", nil);
        _noServerWarning = NSLocalizedString(@"NoServer", nil);
        self.errorTitle = NSLocalizedString(@"Warning", nil);
        self.succeedTitle = NSLocalizedString(@"Succeed", nil);
        _ok = NSLocalizedString(@"OK", nil);
        [self addCode:400 info:NSLocalizedString(@"ClientError", nil) alert:YES succeed:NO];
        [self addCode:500 info:NSLocalizedString(@"ServerError", nil) alert:YES succeed:NO];
    }
    return self;
}
- (void)dealloc {
    self.errorTitle = nil;
    self.succeedTitle = nil;
    [_codeOptions release];
    [self canceled];
    [super dealloc];
}
- (ExproHttpCodeOption *)code4:(int)aCode {
    for (ExproHttpCodeOption *it in _codeOptions) {
        if (it.statusCode == aCode) {
            return it;
        }
    }
    return nil;
}
- (void)addCode:(int)aCode info:(NSString *)aInfo alert:(BOOL)alert succeed:(BOOL)succeed {
    [self removeCode:aCode];
    ExproHttpCodeOption *_codeOption = [[[ExproHttpCodeOption alloc] init] autorelease];
    _codeOption.statusCode = aCode;
    _codeOption.info = aInfo;
    _codeOption.alert = alert;
    _codeOption.succeed = succeed;
    [_codeOptions addObject:_codeOption];
}
- (void)removeCode:(int)aCode {
    ExproHttpCodeOption *_codeOption = [self code4:aCode];
    if (_codeOption) {
        [_codeOptions removeObject:_codeOption];
    }
}
- (void)alert:(NSString *)aTitle warning:(NSString *)aWarning {
    UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:aTitle
                                                         message:aWarning
                                                        delegate:nil
                                               cancelButtonTitle:_ok
                                               otherButtonTitles:nil];
    [_alertView show];
    [_alertView release];
}
- (void)requestDidTimeout:(RKRequest *)request {
    NSLog(@"%@:%@",_errorTitle,_timeOutWarning);
    if ([self shouldAlert]) {
        [self alert:_errorTitle warning:_timeOutWarning];
    }
}
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSString *_title = _errorTitle;
    NSString *_warning = [NSString stringWithFormat:_unknownErrorWarning,response.statusCode];
    BOOL _shouldAlert = YES;
    ExproHttpCodeOption *_option = [self code4:response.statusCode];
    if (_option) {
        if ([_option isSucceed]) {
            _title = _succeedTitle;
            NSDictionary *headers = [response allHeaderFields];
            NSString *cookie = [headers objectForKey:@"Set-Cookie"];
            if (cookie) {
                [ExproRestDelegate setCookie:cookie];
            }
        }
        _shouldAlert = [_option shouldAlert];
        _warning = _option.info;
    }
    NSLog(@"%@:%@",_title,_warning);
    if ([self shouldAlert] && _shouldAlert) {
        [self alert:_title warning:_warning];
    }
    [self succeedWithoutData];
}
- (void)succeedWithoutData {
    
}
- (void)succeed:(id)object {
    _request = nil;
}
- (void)succeed4Parallel:(NSArray *)array {
    _request = nil;
}
- (void)failed:(NSError *)error {
    _request = nil;
    NSString *_error = [error localizedDescription];
    NSLog(@"%@:%@",_errorTitle,_error);
    if ([self shouldAlert]) {
        if ([_error isEqualToString:@"Could not connect to the server."]) {
            [self alert:_errorTitle warning:NSLocalizedString(@"NoServer", nil)];
        }
        else if ([_error isEqualToString:@"The request timed out."]) {
            [self alert:_errorTitle warning:NSLocalizedString(@"TimeOut", nil)];
        }
    }
}
- (void)canceled {
    if (_request) {
        if ([_request isLoading]) {
            [_request cancel];
        }
        [_request release];
        _request = nil;
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
    [self failed:error];
    if ([_reserver respondsToSelector:_failedCallBack]) {
        [_reserver performSelector:_failedCallBack];
    }
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    if (_acceptParallelResults) {
        return;
    }
    [self succeed:object];
    if ([_reserver respondsToSelector:_succeedCallBack]) {
        [_reserver performSelector:_succeedCallBack withObject:object];
    }
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (_acceptParallelResults) {
        [self succeed4Parallel:objects];
        //add by gbo for 204 status code
        if ([objectLoader isEqual:[objects objectAtIndex:0]]) {
            if ([_reserver respondsToSelector:_cancelCallBack]) {
                [_reserver performSelector:_cancelCallBack];
            }
        }
        else {
            if ([_reserver respondsToSelector:_succeedCallBack]) {
                [_reserver performSelector:_succeedCallBack withObject:objects];
            }
        }
    }
}
- (void)cancel {
    [self canceled];
    if ([_reserver respondsToSelector:_cancelCallBack]) {
        [_reserver performSelector:_cancelCallBack];
    }

}

- (void)requestURL:(NSString *)aURL method:(RKRequestMethod)aMethod params:(NSDictionary *)params mapping:(RKObjectMapping *)aMapping {
    [self canceled];
    _request = [[[RKObjectManager sharedManager] loadObjectsAtResourcePath:aURL delegate:self block:^(RKObjectLoader *loader) {
        loader.method = aMethod;
        loader.params = params;
        if (aMapping) {
            loader.objectMapping = aMapping;
        }
        if ([ExproRestDelegate cookie]) {
            [loader.URLRequest addValue:[ExproRestDelegate cookie] forHTTPHeaderField:@"Set-Cookie"];
        }
    }] retain];
}

- (void)requestURL:(NSString *)aURL method:(RKRequestMethod)aMethod object:(id)aObject mapping:(RKObjectMapping *)aMapping serialMapping:(RKObjectMapping *)aSerialMapping {
    [self canceled];
    _request = [[[RKObjectManager sharedManager] loadObjectsAtResourcePath:aURL delegate:self block:^(RKObjectLoader *loader) {
        loader.method = aMethod;
        if (aSerialMapping) {
            loader.serializationMapping = aSerialMapping;
        }
        loader.serializationMIMEType = @"application/json";
        loader.sourceObject = aObject;
        if (aMapping) {
            loader.objectMapping = aMapping;
        }
        if ([ExproRestDelegate cookie]) {
            [loader.URLRequest addValue:[ExproRestDelegate cookie] forHTTPHeaderField:@"Set-Cookie"];
        }
    }] retain];
}
+ (NSString *)cookie {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    return app.cookie;
}
+ (void)setCookie:(NSString *)cookie {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.cookie = cookie;
}
@end
