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
        [self addCode:200 info:NSLocalizedString(@"modifyOK", nil) alert:NO succeed:YES];
        [self addCode:201 info:NSLocalizedString(@"registerOK", nil) alert:NO succeed:YES];
        [self addCode:202 info:NSLocalizedString(@"deleteOK", nil) alert:NO succeed:YES];
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


- (void)modify:(NSString *)memId cellPhone:(NSString *)cellphone name:(NSString *)name petName:(NSString *)petName 
         email:(NSString *)email idCard:(NSString *)idCard comment:(NSString *)comment privacy:(NSString *)privacy
           sex:(NSString *)sex saving:(NSString *)savings point:(NSString *)point dueTime:(NSDate *)dueTime
         birth:(NSString *)birthDate  memPetName:(NSString *)memPetName
{
    //查找是否存在会员用户
    NSFetchRequest *request = [ExproMember fetchRequest];
    NSPredicate *predicate = nil;
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"(gid=%@)" ];
    
    NSMutableArray *userparams = [[NSMutableArray alloc]initWithObjects:memId, nil];
    
    predicate = [NSPredicate predicateWithFormat:str argumentArray:userparams];
    
    NSLog(@"%@",predicate);
    
    request.predicate = predicate;
    NSArray *deals = [ExproMember objectsWithFetchRequest:request];
    ExproMember *member = nil;
    BOOL isExis=NO;
    if (deals.count)
    {
        member = (ExproMember *)[deals objectAtIndex:0];
        isExis=YES;
    }
    member.petName = memPetName;
    member.dueTime = dueTime;
    member.point = [NSNumber numberWithDouble:[point doubleValue]];
    member.savings = [NSNumber numberWithDouble:[savings doubleValue]];
    member.comment = comment;
    member.privacy = [NSNumber numberWithInt:privacy.intValue];
    [[RKObjectManager sharedManager].objectStore save:nil];
    
    NSDictionary *params;
    if (isExis)
    {
        NSLog(@"mempetName %@",memPetName);
        NSLog(@"privacy%@",predicate);
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  member.gid,@"_id",
                  memPetName,@"pet_name",       
                  member.user.cellphone,@"cellphone",
                  @"1",@"role_id",
                  @"1",@"state",
                  member.user.sex.stringValue,@"sex",
                  [self dateToString:member.user.birthday],@"birthday",
                  [self dateToString:dueTime],@"due_time",
                  member.user.gid.stringValue,@"user_id",
                  privacy,@"privacy",
                  point,@"point",
                  savings,@"savings",
                  comment,@"comment",
                  nil];
    }
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass: [NSMutableDictionary class]];
    RKObjectMapping *memberMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [memberMapping mapKeyPathsToAttributes:@"_id", @"gid",nil];
    [mapping mapKeyPath:@"member" toRelationship:@"member" withMapping:memberMapping];
    [self requestURL:@"/member" method:RKRequestMethodPUT params:params mapping:mapping];    
}

- (void)delete:(NSInteger)memId
{
     //NSString *url = [NSString stringWithFormat:@"/store/%i",storeId];
       NSString *url = [NSString stringWithFormat:@"/member/%i",memId];
      [self requestURL:url method:RKRequestMethodDELETE params:nil mapping:nil];  
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
