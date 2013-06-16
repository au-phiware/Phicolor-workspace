//
//  PhiColorViewController.m
//  PhiColorSample
//
//  Created by Corin Lawson on 16/06/13.
//  Copyright (c) 2013 Corin Lawson. All rights reserved.
//

#import "PhiColorViewController.h"

@implementation PhiColorViewController

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
