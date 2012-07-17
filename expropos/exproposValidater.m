//
//  exproposValidater.m
//  expropos
//
//  Created by chen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposValidater.h"

@implementation exproposValidater

- (id)init {
    self = [super init];
    if (self) {
        
       // *  400-说明请求参数有错
      //  *  202-说明user表中无cellphone->创建member and 创建user
       // *  404-说明user表有cellphone，但member表中没有与user关联的数据->创建////member and 关联user_id
      //  *  405-说明user和member中都有数据，->不允许创建。
        [self addCode:200 info:NSLocalizedString(@"canCreate", nil) alert:NO succeed:YES];
        self.succeedTitle = NSLocalizedString(@"sigoutSucceed", nil);
    }
    return self;
}



-(void)validate:(NSString *)telText
{
   NSString *_resource = [NSString stringWithFormat:@"/memberRegJudge/%@",telText];
    RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [signinMapping mapKeyPathsToAttributes:@"status", @"status",nil]; 
    [self requestURL:_resource method:RKRequestMethodGET params:nil mapping:signinMapping];
    
}
@end