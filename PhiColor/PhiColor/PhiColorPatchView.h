//
//  PhiColorPatch.h
//  ColorWheel
//
//  Created by Corin Lawson on 25/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorWheelController.h"

@interface PhiColorPatchView : UIView <PhiColorWheelResponder> {
	id delegate;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) id delegate;

- (IBAction)editColor:(id)sender;

@end
