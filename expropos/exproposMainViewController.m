#import "exproposMainViewController.h"
#import "exproposAppDelegate.h"
#import "exproposViewController.h"



@interface exproposMainViewController ()

@end

@implementation exproposMainViewController
@synthesize menu = _menu;
@synthesize menuTool = _menuTool;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize signout = _signout;





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
    _signout = [[exproposSignout alloc]init];
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
   // [self.splitViewController.viewControllers objectAtIndex:0]
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
    
   // [[RKClient sharedClient] get:@"/signout" delegate:self];
    _signout.reserver = self;
    _signout.succeedCallBack = @selector(didSignout);
     _signout.contrller = self;
    [_signout signout];
}


-(void)didSignout
{
        exproposAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    
}



@end
