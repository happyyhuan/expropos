//
//  exproposMemberManager.h
//  expropos
//
//  Created by haitao chen on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproRestDelegate.h"
#import "ExproGoods.h"

@interface exproposGoodsManager : ExproRestDelegate

-(void)addGoods:(NSDictionary*)goodsInfo;
-(void)updateGoods:(ExproGoods*)goods;
-(void)deleteGoods:(NSString *)gid;
@end
