//
//  GSBAppDelegate.m
//  GoogleSearchBridge
//
//  Created by  on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
  [self.window makeKeyAndVisible];
  
  return YES;
}


@end
