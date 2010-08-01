
#import "CountdownAppDelegate.h"
#import "CountdownViewController.h"

@implementation CountdownAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc
{
	[viewController release];
	[window release];
	[super dealloc];
}

@end
