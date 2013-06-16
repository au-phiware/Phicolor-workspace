//
//  PhiColorPatch.m
//  ColorWheel
//
//  Created by Corin Lawson on 25/08/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorPatchControl.h"
#import "PhiColorWheelView.h"

@implementation PhiColorPatchControl

@synthesize delegate;

+ (Class)layerClass {
	return [CAShapeLayer class];
}

- (BOOL)canBecomeFirstResponder {
	return self.window != nil;
}

- (BOOL)becomeFirstResponderAnimated:(BOOL)animate {
	if ([super becomeFirstResponder]) {
		[self editColor:nil animated:animate];
		return YES;
	}
	return NO;
}
- (BOOL)becomeFirstResponder {
	return [self becomeFirstResponderAnimated:YES];
}

- (BOOL)resignFirstResponderAnimated:(BOOL)animate {
	if ([super resignFirstResponder]) {
		PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
		[wheel setDelegate:nil];
		[wheel setWheelVisible:NO animated:animate];
		return YES;
	}
	return NO;
}
- (BOOL)resignFirstResponder {
	return [self resignFirstResponderAnimated:YES];
}

- (void)setupPath {
	CAShapeLayer *theLayer = (CAShapeLayer *)self.layer;
	CGMutablePathRef path = CGPathCreateMutable();
	if (theLayer.fillColor) {
		CGPathAddEllipseInRect(path, NULL, self.bounds);
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
	((CAShapeLayer *)self.layer).path = path;
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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self setupLayer];
		[self setupGestureRecognizers];
    }
    return self;
}

-(UIColor *)color {
	return [UIColor colorWithCGColor:((CAShapeLayer *)self.layer).fillColor];
}

- (void)setColor:(UIColor *)color {
	CAShapeLayer *theLayer = (CAShapeLayer *)self.layer;
	if (!CGColorEqualToColor(color.CGColor, theLayer.fillColor)) {
		BOOL needsResetup = NO;
		if (color.CGColor) {
			if (!theLayer.fillColor)
				needsResetup = YES;
			theLayer.fillColor = color.CGColor;
		} else {
			if (theLayer.fillColor)
				needsResetup = YES;
			theLayer.fillColor = NULL;
		}
		if (needsResetup) {
			[self setupPath];
		}
		if ([delegate respondsToSelector:@selector(colorDidChange)])
			[delegate colorDidChange];
	}
}

- (IBAction)editColor:(id)sender {
	[self editColor:sender animated:YES];
}
- (IBAction)editColor:(id)sender animated:(BOOL)animate {
	PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
	[wheel setWheelColor:((CAShapeLayer *)self.layer).fillColor];
	[wheel setTargetPoint:self.center inView:self.superview];
	[wheel setDelegate:self];
	[wheel setWheelVisible:YES animated:animate];
	self.color = [[wheel wheelView] color];
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
