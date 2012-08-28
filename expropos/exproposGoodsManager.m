//
//  exproposMemberManager.m
//  expropos
//
//  Created by haitao chen on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposGoodsManager.h"
#import "ExproGoods.h"
#import "ExproGoodsType.h"

@implementation exproposGoodsManager
- (id)init {
    self = [super init];
    if (self) {
        [self addCode:201 info:NSLocalizedString(@"createSucceed", nil) alert:NO succeed:YES];
        [self addCode:200 info:NSLocalizedString(@"UpdateSucceed", nil) alert:NO succeed:YES];
         [self addCode:202 info:NSLocalizedString(@"deleteSucceed", nil) alert:NO succeed:YES];
        [self addCode:502 info:NSLocalizedString(@"server error", nil) alert:NO succeed:NO];
        
        self.succeedTitle = NSLocalizedString(@"GoodsSucceed", nil);
        self.errorTitle = NSLocalizedString(@"GoodsFailed", nil);
        
    }
    return self;
}


-(void)addGoods:(NSDictionary *)goodsInfo
{
  
    NSLog(@"%@",goodsInfo);
    [self requestURL:@"/goods" method:RKRequestMethodPOST params:goodsInfo mapping:nil];

}
-(void)updateGoods:(ExproGoods*)goods;
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:goods.createTime];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:goods.name,@"name",goods.state,@"state",goods.price,@"price",[NSNumber numberWithInt:goods.gid.intValue],@"_id",[NSNumber numberWithInt:goods.type.gid.intValue],@"type_id", goods.code,@"code",goods.comment,@"comment",currentDateStr,@"create_time", nil];
    [self requestURL:@"/goods" method:RKRequestMethodPUT params:params mapping:nil];
 
}
-(void)deleteGoods:(NSString *)gid
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [mapping mapKeyPath:@"_ids" toAttribute:@"gid"];
    [[RKObjectManager sharedManager].mappingProvider registerMapping:mapping withRootKeyPath:@"goods"];
    NSString *url = [NSString stringWithFormat:@"/goods/%@",gid];
    [self requestURL:url method:RKRequestMethodDELETE params:nil mapping:mapping];
}
@end
