//
//  exproposMyTableView.h
//  expropos
//
//  Created by haitao chen on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyTableViewDataSource;
@protocol MyTableViewDelegate;
@interface exproposMyTableView : UITableView <UITableViewDelegate,UITableViewDataSource>
@property (assign) IBOutlet id<MyTableViewDataSource> myTableViewDataSource;
@property (assign) IBOutlet id<MyTableViewDelegate>   myTableViewDelegate;

-(void)reloadDatas;
@end

@protocol MyTableViewDataSource <NSObject>
@required
-(NSInteger)numberOfSectionsInMyTableView:(exproposMyTableView *)tableView;
-(NSInteger)myTableView:(exproposMyTableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)myTableView:(exproposMyTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional


@end

@protocol MyTableViewDelegate <NSObject>

@optional
-(void)myTableView:(exproposMyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end