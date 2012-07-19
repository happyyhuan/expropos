//
//  exproposMemberRegisterController.h
//  expropos
//
//  Created by chen on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
@interface exproposMemberRegisterController : UITableViewController<UITextFieldDelegate>

{

}
@property (strong,nonatomic )exproposMainViewController *mainViewController;
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic, strong) NSString *telphone;

@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *petName;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDate *birth;
@property (nonatomic,strong) NSMutableArray *levelItem;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic) BOOL account;
@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) NSString *memPetName;
@property (nonatomic,strong) NSString *savings;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,strong) NSDate *dueTime;
@property (nonatomic,strong) NSMutableArray *privacyItem;
@property (nonatomic,strong) NSString *point;
@property (nonatomic,strong) NSString *dateSel;


@end
