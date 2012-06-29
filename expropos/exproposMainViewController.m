#import "exproposMainViewController.h"
#import "exproposAppDelegate.h"
#import "exproposViewController.h"



@interface exproposMainViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation exproposMainViewController
@synthesize menu = _menu;
@synthesize menuTool = _menuTool;
@synthesize masterPopoverController = _masterPopoverController;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *data = [self.menuTool.items mutableCopy];
    [data removeObject:self.menu];
    self.menuTool.items = data;
    self.splitViewController.delegate = self;

}

- (void)viewDidUnload
{
    
    [self setMenu:nil];
    [self setMenuTool:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}






#pragma mark UISplitViewControllerDelegate Methods

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
    
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"菜单";
    NSMutableArray *data = [self.menuTool.items mutableCopy];
    [data removeObject:self.menu];
    [data insertObject:barButtonItem atIndex:0];
    self.menuTool.items = data;
    
    self.masterPopoverController = pc;
}


-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    NSMutableArray *data = [self.menuTool.items mutableCopy];
    [data removeObject:self.menu];
    [data removeObject:barButtonItem];
    self.menuTool.items = data;
    self.masterPopoverController = nil;
    barButtonItem = nil;
}
#pragma mark -

- (IBAction)logout:(UIBarButtonItem *)sender {
    
    [[RKClient sharedClient] get:@"/signout" delegate:self];
    
}

#pragma mark PKRequestDelegate Method
-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if(response.statusCode == 200){
        exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    }
}


-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    RKLogInfo(@"logout error:%@",[error localizedDescription]);
}
#pragma mark -
@end
