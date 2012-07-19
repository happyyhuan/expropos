//
//  exproposRegistr.m
//  expropos
//
//  Created by chen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposRegistr.h"
#import "ExproMember.h"
#import "ExproUser.h"

@implementation exproposRegistr

- (id)init {
    self = [super init];
    if (self) {
        [self addCode:201 info:NSLocalizedString(@"registerOK", nil) alert:NO succeed:YES];
        [self addCode:400 info:NSLocalizedString(@"badRequset", nil) alert:YES succeed:NO];
        [self addCode:404 info:NSLocalizedString(@"notAcceptable", nil) alert:YES succeed:NO];
        self.succeedTitle = NSLocalizedString(@"LoginSucceed", nil);
        self.errorTitle = NSLocalizedString(@"LoginFailed", nil);
        self.reserver = self;
    }
    return self;
}

- (void)registr:(NSString *)cellphone name:(NSString *)name petName:(NSString *)petName 
          email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment
sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSString *)dueTime

          birth:(NSString *)birthDate  memPetName:(NSString *)memPetName
{
    
    //查找是否存在user用户
    NSFetchRequest *request = [ExproUser fetchRequest];
    NSPredicate *predicate = nil;
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"(cellphone=%@)" ];
    
    NSMutableArray *userparams = [[NSMutableArray alloc]initWithObjects:cellphone, nil];
    
    predicate = [NSPredicate predicateWithFormat:str argumentArray:userparams];
    
    NSLog(@"%@",predicate);
    
    request.predicate = predicate;
    NSArray *deals = [ExproUser objectsWithFetchRequest:request];
    ExproUser *user = nil;
    BOOL isExis=NO;
    if (deals.count)
    {
        user = (ExproUser *)[deals objectAtIndex:0];
        isExis=YES;
    }
    
    
    //RKObjectMapping *signinMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    RKManagedObjectMapping *signinMapping = [RKObjectMapping mappingForClass: [ExproMember class]];
    NSDictionary *params;
    if (isExis)
    {
       NSLog(@"mempetName %@",memPetName);
       params = [NSDictionary dictionaryWithObjectsAndKeys:
                            memPetName,@"pet_name",       
                            user.cellphone,@"cellphone",
                            @"1",@"role_id",
                             @"1",@"state",
                            user.sex.stringValue,@"sex",
                            [self dateToString:user.birthday],@"birthday",
                            dueTime,@"due_time",
                            user.gid.stringValue,@"user_id",
                            @"0",@"privacy",
                            point,@"point",
                            savings,@"savings",
                            comment,@"comment",
                            nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  memPetName,@"pet_name",
                  cellphone,@"cellphone",
                  @"1",@"role_id",
                  @"1",@"state",
                  sex,@"sex",
                  birthDate,@"birthday",
                  dueTime,@"due_time",
                  @"",@"user_id",
                  @"0",@"privacy",
                  point,@"point",
                  savings,@"savings",
                  comment,@"comment",
                  nil];

    }
    [self requestURL:@"/member" method:RKRequestMethodPOST params:params mapping:nil];
    

    
}


-(NSString *)dateToString:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27    
    return dateStr;
}
@end
