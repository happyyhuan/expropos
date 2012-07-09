//
//  exproposMyTableView.m
//  expropos
//
//  Created by haitao chen on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposMyTableView.h"

@implementation exproposMyTableView
@synthesize myTableViewDataSource = _myTableViewDataSource;
@synthesize myTableViewDelegate = _myTableViewDelegate;

-(void)reloadDatas
{
    [super reloadData];
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_myTableViewDataSource numberOfSectionsInMyTableView: (exproposMyTableView*)tableView ];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_myTableViewDataSource myTableView:(exproposMyTableView*)tableView numberOfRowsInSection:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_myTableViewDataSource myTableView:(exproposMyTableView*)tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableViewDelegate myTableView:(exproposMyTableView *)tableView didSelectRowAtIndexPath:indexPath];
}

@end
