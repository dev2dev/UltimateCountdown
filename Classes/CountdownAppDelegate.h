
@class CountdownViewController;

@interface CountdownAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow* window;
	CountdownViewController* viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet CountdownViewController* viewController;

@end
