//
//  PhiColorPatch.h
//  ColorWheel
//
//  Created by Corin Lawson on 25/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorWheelController.h"

@class PhiColorPatchControl;

@protocol PhiColorPatchControlDelegate <NSObject>

@optional

- (BOOL)colorPatchControlShouldBeginEditing:(PhiColorPatchControl *)colorPatch;
- (void)colorPatchControlDidBeginEditing:(PhiColorPatchControl *)colorPatch;
- (BOOL)colorPatchControlShouldEndEditing:(PhiColorPatchControl *)colorPatch;
- (void)colorPatchControlDidEndEditing:(PhiColorPatchControl *)colorPatch;
- (BOOL)colorPatchControl:(PhiColorPatchControl *)colorPatch shouldChangeToColor:(CGColorRef)aColor;
- (CGColorRef)colorPatchControl:(PhiColorPatchControl *)colorPatch changeToColor:(CGColorRef)aColor;

@end

@interface PhiColorPatchControl : UIControl <PhiColorWheelResponder> {
	IBOutlet id<PhiColorPatchControlDelegate> delegate;
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL didInitColor;

- (void)editColor:(id)sender animated:(BOOL)animate;
- (IBAction)editColor:(id)sender;
- (BOOL)becomeFirstResponderAnimated:(BOOL)animate;
- (BOOL)resignFirstResponderAnimated:(BOOL)animate;

@end
