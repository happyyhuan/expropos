//
//  exproposNumKeyboard.h
//  expropos
//
//  Created by haitao chen on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPStupidButton.h"
#import "ExproGoods.h"

@interface exproposNumKeyboard : UIViewController <ButtonClick>
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIViewController *viewController;

@property (strong, nonatomic) IBOutlet UITextField *goodsNum;
@property (strong, nonatomic) IBOutlet UIButton *deleteOneNum;
@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *keys;
@property (strong, nonatomic) ExproGoods *goods;

- (IBAction)deleteOneGoodsNum:(id)sender;


@end
