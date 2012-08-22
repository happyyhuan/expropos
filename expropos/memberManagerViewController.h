//
//  memberManagerViewController.h
//  expropos
//
//  Created by chen on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exproposMainViewController.h"
#import "ExproMultipleTableView.h"
#import "exproposMemberRegisterController.h"

@interface memberManagerViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UITableView *memberTabelView;
@property (strong, nonatomic) IBOutlet UIView *memberDetailView;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *queryView;

@property (nonatomic,strong) NSMutableArray *memberItems;
@property (nonatomic,strong)  NSMutableArray *allMember;



@property (strong, nonatomic) IBOutlet UILabel *telphone;
@property (strong, nonatomic) IBOutlet UILabel *point;
@property (strong, nonatomic) IBOutlet UILabel *privacy;
@property (strong, nonatomic) IBOutlet UILabel *saving;
@property (strong, nonatomic) IBOutlet UILabel *dueTime;

@property (strong, nonatomic) UISplitViewController *myRootViewController;
@property (strong, nonatomic) IBOutlet UILabel *nameInfo;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *modifyButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic) NSInteger *currentMemberId;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) exproposMemberRegisterController *memberRegister;

@property (strong,nonatomic) exproposMainViewController *mainViewControll;



- (IBAction)addMember:(id)sender;


- (IBAction)modifyMember:(id)sender;
- (IBAction)backToMemu:(id)sender;

- (IBAction)delMember:(id)sender;

@end