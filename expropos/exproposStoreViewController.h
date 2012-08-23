//
//  exproposStoreViewController.h
//  expropos
//
//  Created by chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"


@interface exproposStoreViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *storesTabelView;
@property (strong, nonatomic) IBOutlet UIView *storeDetailView;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *queryView;

@property (nonatomic,strong) NSMutableArray *storeItems;
@property (nonatomic,strong)  NSMutableArray *allStore;
@property (strong, nonatomic) IBOutlet UILabel *storeNO;
@property (strong, nonatomic) IBOutlet UITextView *storeAddress;
@property (strong, nonatomic) IBOutlet UITextView *storeTrainInfo;
@property (strong, nonatomic) IBOutlet UITextView *storeNotice;
@property (strong, nonatomic) IBOutlet UILabel *storeState;
@property (strong, nonatomic) IBOutlet UITextView *storeComment;


@property (strong, nonatomic) UISplitViewController *myRootViewController;
@property (strong, nonatomic) IBOutlet UILabel *nameInfo;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *modifyButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *delButton;
@property (nonatomic) NSNumber *currentStoreId;



- (IBAction)addStore:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)modifyStore:(id)sender;
- (IBAction)backToMemu:(id)sender;

- (IBAction)delStore:(id)sender;

@end
