//
//  exproposPayViewController.h
//  expropos
//
//  Created by haitao chen on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposShowDealOperateViewController.h"
@protocol ButtonClick;

@interface exproposPayViewController : UIViewController <ButtonClick>
@property (strong, nonatomic) IBOutlet UILabel *shouleGetMoney;
@property (strong, nonatomic) IBOutlet UIView *getRealMoney;
@property (strong, nonatomic) IBOutlet UIView *keyboards;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) exproposShowDealOperateViewController *showOperate;
@property (strong, nonatomic) IBOutlet UILabel *shouldPopMoney;
- (IBAction)payTypeChanged:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UITextField *haveGetMoney;


@property (strong, nonatomic) IBOutletCollection(JPStupidButton) NSArray *mykeyboards;

- (IBAction)finish:(id)sender;


@end
