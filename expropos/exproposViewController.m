//
//  exproposViewController.m
//  expropos
//
//  Created by gbo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "exproposViewController.h"
#import "exproposSign.h"

@interface exproposViewController ()
@property (strong) exproposSign *sign;
@end

@implementation exproposViewController

@synthesize sign = _sign;

- (IBAction)login:(id)sender {
    self.sign = [[exproposSign alloc]init];
    [self.sign signin:@"18912345678" password:@"123456"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
