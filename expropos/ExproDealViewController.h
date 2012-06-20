//
//  ExproDealViewController.h
//  expropos
//
//  Created by 昊 曹 on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExproMultipleTableView.h"

@class ExproDeal;
@class ExproDealUploader;

@interface ExproDealViewController : UIViewController<ExproMutableTableViewDelegate,ExproMutableTableViewDataSource> {
    ExproMultipleTableView *_tableView;
    ExproDeal *_deal;
    ExproDealUploader *_uploader;
}
@property (nonatomic, strong) IBOutlet ExproMultipleTableView *tableView;
@property (nonatomic, strong) ExproDeal *deal;
@end
