//
//  exproposPloyeeManagerViewController.h
//  expropos
//
//  Created by chen on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exproposPloyeeManagerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *ployTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *registButton;
@property (strong, nonatomic) IBOutlet UIButton *modifyButton;
@property (strong, nonatomic) IBOutlet UIButton *delButton;
@property (strong, nonatomic) IBOutlet UILabel *telphone;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *idCard;

@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *roleName;


@property (nonatomic,strong) NSMutableArray *ployeeItems;
@property (nonatomic,strong)  NSMutableArray *allPloyee;
@property (strong, nonatomic) UISplitViewController *myRootViewController;

@property (nonatomic) NSInteger *currentPloyeeId;

- (IBAction)registPloyee:(id)sender;
- (IBAction)modifyPloyee:(id)sender;
- (IBAction)deletePloyee:(id)sender;
- (IBAction)goBack:(id)sender;

@end
