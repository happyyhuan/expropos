//
//  expropoStoreEditViewController.h
//  expropos
//
//  Created by chen on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproStore.h"
#import "exproposStoreViewController.h"
#import "exproposStoreEdit.h"

@interface expropoStoreEditViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UILabel *editLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, strong) NSString *storeName;
@property (nonatomic,strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *storeNo;
@property (nonatomic,strong) NSString *storeTransit;
@property (nonatomic,strong) NSString *storeComment;
@property (nonatomic,strong) NSString *storeNotice;
@property (nonatomic,strong) NSString *storeState;

@property (nonatomic,strong) NSMutableArray *privacyItem;
@property (nonatomic,strong) UIPopoverController *popover;

@property (nonatomic,strong)  ExproStore *exproStore;
@property (nonatomic,strong) exproposStoreEdit *exproStoreEdit;

@property (nonatomic,strong) exproposStoreViewController *storeView;



- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;

@end
