//
//  PhiColorAppDelegate.m
//  PhiColorSample
//
//  Created by Corin Lawson on 16/06/13.
//  Copyright (c) 2013 Corin Lawson. All rights reserved.
//

#import "PhiColorAppDelegate.h"

@implementation PhiColorAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
