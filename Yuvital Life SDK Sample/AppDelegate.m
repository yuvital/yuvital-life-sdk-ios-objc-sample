#import "AppDelegate.h"

@import UIKit;
// @import ReactBrownfield;
// @import YuvitalLifeSDK;

#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    
    NSLog(@"didFinishLaunchingWithOptions called");
    
    // Configure React Native brownfield host (matches Swift sample logic)
    // ReactNativeBrownfield.shared.bundle = ReactNativeBundle;
    // [ReactNativeBrownfield.shared startReactNative];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootVC];

    self.window.rootViewController = navController;
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    [self.window makeKeyAndVisible];

    return YES;
}

@end


