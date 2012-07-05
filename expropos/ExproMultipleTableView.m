//
//  exproposMyTableView.m
//  expropos
//
//  Created by haitao chen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExproMultipleTableView.h"

@implementation ExproMultipleTableView
@synthesize multipleDataSource = _multipleDataSource;
@synthesize multipleDelegate = _multipleDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_multipleDataSource multipleTableView:(ExproMultipleTableView *)tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_multipleDataSource respondsToSelector:@selector(multipleTableView:heightForHeaderInSection:)]) {
        return [_multipleDelegate multipleTableView:(ExproMultipleTableView *)tableView heightForHeaderInSection:section];
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_multipleDelegate respondsToSelector:@selector(multipleTableView:heightForCellAtIndexPath:)]) {
        return [_multipleDelegate multipleTableView:(ExproMultipleTableView *)tableView heightForCellAtIndexPath:indexPath];
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_multipleDataSource respondsToSelector:@selector(multipleTableView:titleForSegment:)]) {
        NSInteger segments = [_multipleDataSource numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView];
        CGFloat height = [self.delegate tableView:tableView heightForHeaderInSection:section];
        CGFloat width = self.frame.size.width;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        CGFloat orgin = 0;
        for (NSInteger index=0; index<segments; index++) {
            CGFloat contentWidth = [_multipleDataSource multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:index]*self.frame.size.width;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(orgin, 0, contentWidth, height)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [_multipleDataSource multipleTableView:(ExproMultipleTableView *)tableView titleForSegment:index];
            [titleView addSubview:label];
            orgin += contentWidth;
        }
        if ([_multipleDelegate respondsToSelector:@selector(multipleTableView:backgroundColorForHeaderInSection:)]) {
            titleView.backgroundColor = [_multipleDelegate multipleTableView:(ExproMultipleTableView *)tableView backgroundColorForHeaderInSection:section];
        }
        return titleView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        NSInteger segments = [_multipleDataSource numberOfSegmentInMultipleTableView:(ExproMultipleTableView *)tableView];
        CGFloat orgin = 0;
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        for (NSInteger index=0; index<segments; index++) {
            CGFloat contentWidth = [_multipleDataSource multipleTableView:(ExproMultipleTableView *)tableView proportionForSegment:index]*self.frame.size.width;
            UIView *background = [[UIView alloc] initWithFrame:CGRectMake(orgin, 0, contentWidth, height)];
            if ([_multipleDelegate respondsToSelector:@selector(multipleTableView:backgroundColorSegment:)]) {
                background.backgroundColor = [_multipleDelegate multipleTableView:(ExproMultipleTableView *)tableView backgroundColorSegment:index];
            }
            UIView *view = [_multipleDataSource multipleTableView:(ExproMultipleTableView *)tableView viewForSegment:index indexPath:indexPath];;
            [background addSubview:view];
            [cell addSubview:background];
            orgin += contentWidth;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end