#import "AppDelegate.h"
#import "Yuvital_Life_SDK_Sample-Swift.h"
@import UIKit;

#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {

    [YuvitalLifeSdkBridge configure];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootVC];

    self.window.rootViewController = navController;
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    [self.window makeKeyAndVisible];

    return YES;
}

@end


