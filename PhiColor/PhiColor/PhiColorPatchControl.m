//
//  PhiColorPatch.m
//  ColorWheel
//
//  Created by Corin Lawson on 25/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorPatchControl.h"
#import "PhiColorWheelView.h"

@interface PhiColorPatchControl (PhiColorPatchAnimationDelegate)
@property (nonatomic, assign) BOOL didInitColor;
@end

@interface PhiColorPatchAnimationDelegate : NSObject
{
	PhiColorPatchControl *owner;
}

-(id)initWithOwner:(PhiColorPatchControl *)view;

@end

@implementation PhiColorPatchAnimationDelegate

-(id)initWithOwner:(PhiColorPatchControl *)target {
	if ((self = [super init])) {
		owner = target;
	}
	return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if (flag && owner.didInitColor)
		[owner sendActionsForControlEvents:UIControlEventValueChanged];
	owner.didInitColor = YES;
}

- (void)dealloc {
	[super dealloc];
}

@end


@implementation PhiColorPatchControl

- (BOOL)didInitColor {
	return didInitColor;
}
- (void)setDidInitColor:(BOOL)flag {
	didInitColor = flag;
}

+ (Class)layerClass {
	return [CAShapeLayer class];
}

- (BOOL)canBecomeFirstResponder {
	return self.window != nil && (![delegate respondsToSelector:@selector(colorPatchControlShouldBeginEditing:)] || [delegate colorPatchControlShouldBeginEditing:self]);
}

- (BOOL)becomeFirstResponderAnimated:(BOOL)animate {
	if ([super becomeFirstResponder]) {
		[self editColor:nil animated:animate];
        if ([delegate respondsToSelector:@selector(colorPatchControlDidBeginEditing:)])
             [delegate colorPatchControlDidBeginEditing:self];
		return YES;
	}
	return NO;
}
- (BOOL)becomeFirstResponder {
	return [self becomeFirstResponderAnimated:YES];
}

- (BOOL)canResignFirstResponder {
	return ![delegate respondsToSelector:@selector(colorPatchControlShouldEndEditing:)] || [delegate colorPatchControlShouldEndEditing:self];
}

- (BOOL)resignFirstResponderAnimated:(BOOL)animate {
	if ([super resignFirstResponder]) {
		PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
		[wheel setDelegate:nil];
		[wheel setWheelVisible:NO animated:animate];
        if ([delegate respondsToSelector:@selector(colorPatchControlDidEndEditing:)])
            [delegate colorPatchControlDidEndEditing:self];
		return YES;
	}
	return NO;
}
- (BOOL)resignFirstResponder {
	return [self resignFirstResponderAnimated:YES];
}

- (void)layoutSubviews {
    [self setupPath];
    [super layoutSubviews];
}

- (void)setupPath {
	CAShapeLayer *theLayer = (CAShapeLayer *)self.layer;
	CGRect patchBounds = self.bounds;
	if (patchBounds.size.height > patchBounds.size.width) {
		switch (self.contentVerticalAlignment) {
			case UIControlContentVerticalAlignmentBottom:
				patchBounds.origin.y += (patchBounds.size.height - patchBounds.size.width) / 2.0;
			case UIControlContentVerticalAlignmentCenter:
				patchBounds.origin.y += (patchBounds.size.height - patchBounds.size.width) / 2.0;
			case UIControlContentVerticalAlignmentTop:
				patchBounds.size.height = patchBounds.size.width;
            case UIControlContentVerticalAlignmentFill:
                // No adjustment needed
                break;
		}
	} else {
		switch (self.contentHorizontalAlignment) {
			case UIControlContentHorizontalAlignmentRight:
				patchBounds.origin.x += (patchBounds.size.width - patchBounds.size.height) / 2.0;
			case UIControlContentHorizontalAlignmentCenter:
				patchBounds.origin.x += (patchBounds.size.width - patchBounds.size.height) / 2.0;
			case UIControlContentHorizontalAlignmentLeft:
				patchBounds.size.width = patchBounds.size.height;
            case UIControlContentVerticalAlignmentFill:
                // No adjustment needed
                break;
		}
	}

	CGMutablePathRef path = CGPathCreateMutable();
	if (theLayer.fillColor && self.enabled) {
		CGPathAddEllipseInRect(path, NULL, patchBounds);
	} else {
		CGPathAddArc(path, NULL,
					 CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds),
					 MIN(self.bounds.size.width, self.bounds.size.height) / 2.0,
					 M_PI * 3.0 / 4.0, -M_PI / 4.0, false);
		CGPathAddArc(path, NULL,
					 CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds),
					 MIN(self.bounds.size.width, self.bounds.size.height) / 2.0,
					 M_PI * 3.0 / 4.0, M_PI * 7.0 / 4.0, true);
	}
	theLayer.path = path;
	CGPathRelease(path);
}
- (void)setupLayer {
	[self setupPath];
	((CAShapeLayer *)self.layer).lineWidth = 3.0;
	((CAShapeLayer *)self.layer).lineJoin = kCALineJoinBevel;
	((CAShapeLayer *)self.layer).strokeColor = [UIColor colorWithWhite:0.2 alpha:0.618].CGColor;
}

- (void)setupGestureRecognizers {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
	[self addGestureRecognizer:tap];
	[tap release];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setupLayer];
		[self setupGestureRecognizers];
		didInitColor = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self setupLayer];
		[self setupGestureRecognizers];
		didInitColor = NO;
    }
    return self;
}

-(UIColor *)color {
	return [UIColor colorWithCGColor:((CAShapeLayer *)self.layer).fillColor];
}

- (void)setColor:(UIColor *)color {
    if ([delegate respondsToSelector:@selector(colorPatchControl:shouldChangeToColor:)] && ![delegate colorPatchControl:self shouldChangeToColor:color.CGColor])
        return;
	CAShapeLayer *theLayer = (CAShapeLayer *)self.layer;
	CGColorRef rgbColor;
	if ([delegate respondsToSelector:@selector(colorPatchControl:changeToColor:)])
		rgbColor = [delegate colorPatchControl:self changeToColor:color.CGColor];
	else
		rgbColor = color.CGColor;

	if (!CGColorEqualToColor(color.CGColor, theLayer.fillColor)) {
		BOOL needsResetup = NO;

		if (rgbColor) {
			CGColorSpaceModel csm = CGColorSpaceGetModel(CGColorGetColorSpace(rgbColor));
			if (!theLayer.fillColor)
				needsResetup = YES;

			if (csm == kCGColorSpaceModelCMYK || csm == kCGColorSpaceModelMonochrome) {
				CGColorSpaceRef s = CGColorSpaceCreateDeviceRGB();
				CGFloat rgbComponents[4] = {0.0, 0.0, 0.0, 1.0};
				const CGFloat *colorComponents = CGColorGetComponents(rgbColor);

				if (csm == kCGColorSpaceModelCMYK) {
					rgbComponents[0] = (1.0 - colorComponents[0]) * (1.0 - colorComponents[3]);
					rgbComponents[1] = (1.0 - colorComponents[1]) * (1.0 - colorComponents[3]);
					rgbComponents[2] = (1.0 - colorComponents[2]) * (1.0 - colorComponents[3]);
					rgbComponents[3] = colorComponents[4];
				} else if (csm == kCGColorSpaceModelMonochrome) {
					rgbComponents[0] = rgbComponents[1] = rgbComponents[2] = colorComponents[0];
					rgbComponents[3] = colorComponents[1];
				}

				rgbColor = CGColorCreate(s, rgbComponents);
				theLayer.fillColor = rgbColor;
				CGColorRelease(rgbColor);
				CGColorSpaceRelease(s);
			} else {
				theLayer.fillColor = rgbColor;
			}
		} else {
			if (theLayer.fillColor)
				needsResetup = YES;
			theLayer.fillColor = NULL;
		}

		if (needsResetup) {
			[self setupPath];
		}
		if (CFBooleanGetValue((CFBooleanRef)[CATransaction valueForKey:kCATransactionDisableActions])) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
	}
}

- (id<CAAction>)actionForLayer:(CALayer *)theLayer forKey:(NSString *)key {
	if ([key isEqualToString:@"fillColor"]) {
		CAAnimation *a = [CABasicAnimation animationWithKeyPath:key];
		[a setDelegate:[[[PhiColorPatchAnimationDelegate alloc] initWithOwner:self] autorelease]];
		return a;
	}
	return [super actionForLayer:theLayer forKey:key];
}

- (void)editColor:(id)sender animated:(BOOL)animate {
	PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
	[wheel setWheelColor:((CAShapeLayer *)self.layer).fillColor];
	[wheel setTargetPoint:self.center inView:self.superview];
	[wheel setDelegate:self];
	[wheel setWheelVisible:YES animated:animate];
	self.didInitColor = YES;
	self.color = [[wheel wheelView] color];
}
- (IBAction)editColor:(id)sender {
	[self editColor:sender animated:YES];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	return CGPathContainsPoint([(CAShapeLayer *)self.layer path], NULL, point, [(CAShapeLayer *)self.layer fillRule] == kCAFillRuleEvenOdd);
}

- (void)colorDidChange:(PhiColorWheelView *)colorView {
	self.color = colorView.color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (void)dealloc {
    [super dealloc];
}


@end
