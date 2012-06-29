//
//  exproposGoodSelectedViewController.h
//  expropos
//
//  Created by haitao chen on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exproposGoodSelectedViewController : UITableViewController<UISearchBarDelegate>
@property (nonatomic,strong)UIViewController *viewController;
@property (nonatomic,strong)NSArray *allDatas;
@property (nonatomic,strong)NSMutableArray *datas;

@property (nonatomic,strong)NSMutableArray *searchData;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
