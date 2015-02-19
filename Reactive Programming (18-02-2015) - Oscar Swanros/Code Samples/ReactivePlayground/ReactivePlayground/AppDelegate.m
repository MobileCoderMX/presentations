//
//  AppDelegate.m
//  ReactivePlayground
//
//  Created by Oscar Swanros on 16/02/15.
//  Copyright (c) 2015 MobileCoder. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"

#import <ReactiveCocoa.h>

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
