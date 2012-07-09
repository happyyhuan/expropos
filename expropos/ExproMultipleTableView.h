//
//  exproposMyTableView.h
//  expropos
//
//  Created by haitao chen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExproMutableTableViewDataSource;
@protocol ExproMutableTableViewDelegate;


@interface ExproMultipleTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (assign) IBOutlet id<ExproMutableTableViewDataSource> multipleDataSource;
@property (assign) IBOutlet id<ExproMutableTableViewDelegate>   multipleDelegate;

-(void)reloadDatas;
@end

@protocol ExproMutableTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView;
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:(NSInteger)segment;
- (UIView *)multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:(NSInteger)segment indexPath:(NSIndexPath *)indexPath;
- (NSInteger)multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:(NSInteger)section;
@optional
- (NSString *)multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:(NSInteger)segment;

@end

@protocol ExproMutableTableViewDelegate <NSObject>

@optional
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:(NSInteger)section;
- (UIColor *)multipleTableView:(ExproMultipleTableView *)tableView backgroundColorSegment:(NSInteger)segment;

- (void)multipleTableView:(ExproMultipleTableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath ;

@end