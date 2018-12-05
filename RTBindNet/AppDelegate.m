//
//  AppDelegate.m
//  RTBindNet
//
//  Created by roobo on 2018/8/22.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "AppDelegate.h"
#import "RTAddDeviceViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [RBAccessConfig saveDevelopEnv:RBDevelopEnv_Relese];
    [RBAccessConfig saveAppID:@"mU1MjExYmU3YTFkZ"];
    [RBAccessConfig saveUserID:@"xh:994508d6179536f1ec605d9edea5e22b"];
    [RBAccessConfig saveAccessToken:@"3e647c6172f81784c8e415eccc4fce63"];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES] ;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    RTAddDeviceViewController *connectVC = [[RTAddDeviceViewController alloc] init];
    UINavigationController *addNaviController = [[UINavigationController alloc] initWithRootViewController:connectVC];
    
    self.window.rootViewController = addNaviController;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
