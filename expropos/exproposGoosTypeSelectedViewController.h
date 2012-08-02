//
//  exproposGoosTypeSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMerchant.h"
#import "ExproGoodsType.h"


@interface exproposGoosTypeSelectedViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)ExproMerchant *merchant;
@property (nonatomic,strong)ExproGoodsType *goodsType;
@property (nonatomic,strong)UIViewController *vc;

@end
