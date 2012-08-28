//
//  exproposValidater.m
//  expropos
//
//  Created by chen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposValidater.h"
#import "exproposMemberRegisterController.h"


@implementation exproposValidater
@synthesize registerController=_registerController;

- (id)init {
    self = [super init];
    if (self) {
//        *  200-成功；无user，无member，可创建user+member。
//        *  202-已接受；有user，无商户关联member，可创建member。
//        *  406-无法接受 :说明user和member中都有数据，->不允许创建。
        
        [self addCode:200 info:NSLocalizedString(@"canCreate", nil) alert:NO succeed:YES];
        [self addCode:202 info:NSLocalizedString(@"canCreate", nil) alert:NO succeed:YES];

        [self addCode:406 info:NSLocalizedString(@"canCreate", nil) alert:NO succeed:NO];
        [self addCode:502 info:NSLocalizedString(@"server error", nil) alert:NO succeed:NO];
        
        self.succeedTitle = NSLocalizedString(@"sigoutSucceed", nil);
    }
    return self;
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"reponse.statusCode%i",response.statusCode);
    _registerController.status = [NSString stringWithFormat:@"%i",response.statusCode];
    [super request:request didLoadResponse:response];
    
}

-(void)validate:(NSString *)telText
{
   NSString *_resource = [NSString stringWithFormat:@"/memberRegJudge/%@",telText];
    RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [signinMapping mapKeyPathsToAttributes:@"status", @"status",nil]; 
    [self requestURL:_resource method:RKRequestMethodGET params:nil mapping:signinMapping];
    
}
@end