//
//  ColorWheelView.m
//  ColorWheel
//
//  Created by Corin Lawson on 23/06/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

#import "PhiColorWheelView.h"
#import "PhiColorWheelLayer.h"
#import "PhiColorWheelWedgeSpinAnimation.h"
#import "PhiColorWheelController.h"
#import <UIKit/UIPanGestureRecognizer.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation PhiColorWheelSegmentSlideGestureRecognizer

@synthesize segment;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSMutableSet *ignoredTouches = [NSMutableSet setWithCapacity:[touches count]];
	for (UITouch *touch in [touches allObjects]) {
		if (![(PhiColorWheelLayer *)[[self view] layer] containsPoint:[touch locationInView:[self view]] inSegment:self.segment inLayer:[[self view] layer]]) {
			[ignoredTouches addObject:touch];
		}
	}
	if ([ignoredTouches count]) {
		touches = [touches mutableCopy];
		[(NSMutableSet *)touches minusSet:ignoredTouches];
		for (UITouch *touch in [ignoredTouches allObjects])
			[self ignoreTouch:touch forEvent:event];
	}
	if ([touches count]) {
		[super touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
	}
}

@end

@implementation PhiColorWheelSegmentFlickGestureRecognizer

@synthesize segment;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSMutableSet *ignoredTouches = [NSMutableSet setWithCapacity:[touches count]];
	for (UITouch *touch in [touches allObjects]) {
		if (![(PhiColorWheelLayer *)[[self view] layer] containsPoint:[touch locationInView:[self view]] inSegment:self.segment inLayer:[[self view] layer]]) {
			[ignoredTouches addObject:touch];
		}
	}
	if ([ignoredTouches count]) {
		touches = [touches mutableCopy];
		[(NSMutableSet *)touches minusSet:ignoredTouches];
		for (UITouch *touch in [ignoredTouches allObjects])
			[self ignoreTouch:touch forEvent:event];
	}
	if ([touches count]) {
		[super touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
	}
}

@end

@implementation PhiColorWheelSegmentDoubleTapGestureRecognizer

@synthesize segment;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSMutableSet *ignoredTouches = [NSMutableSet setWithCapacity:[touches count]];
	for (UITouch *touch in [touches allObjects]) {
		if (![(PhiColorWheelLayer *)[[self view] layer] containsPoint:[touch locationInView:[self view]] inSegment:self.segment inLayer:[[self view] layer]]) {
			[ignoredTouches addObject:touch];
		}
	}
	if ([ignoredTouches count]) {
		touches = [touches mutableCopy];
		[(NSMutableSet *)touches minusSet:ignoredTouches];
		for (UITouch *touch in [ignoredTouches allObjects])
			[self ignoreTouch:touch forEvent:event];
	}
	if ([touches count]) {
		[super touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
	}
}

@end


@implementation PhiColorWheelView

+ (void)initialize {
	CFStringRef suiteName = CFSTR("au.com.phiware.colorwheel");
	int anInt;
	CFNumberRef aNumberValue;
	
	anInt = 1;
	aNumberValue = CFNumberCreate(NULL, kCFNumberIntType, &anInt);
	CFPreferencesSetAppValue(CFSTR("include_primary"), aNumberValue, suiteName);
	CFPreferencesSetAppValue(CFSTR("include_secondary"), aNumberValue, suiteName);
	CFRelease(aNumberValue);
	
	CFPreferencesAppSynchronize(suiteName);
}

@synthesize delegate;

- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
	if ([key isEqualToString:@"strength"]
		|| [key isEqualToString:@"baseColor"]
		|| [key isEqualToString:@"addColor"]
		|| [key isEqualToString:@"wheelAngleWeight"])
		return nil;
	return [super actionForLayer:(CALayer *)layer forKey:(NSString *)key];
}

+ (Class)layerClass {
	return [PhiColorWheelLayer class];
}

- (void)setupView {
	self.opaque = NO;
}
- (void)setupWedgeColors {
	CGColorSpaceRef s = CGColorSpaceCreateDeviceCMYK();
	CGFloat colorComponents[5] = {1.0, 0.0, 0.0, 0.0, 1.0};
	CGColorRef c;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults addSuiteNamed:@"au.com.phiware.colorwheel"];
	BOOL includeSecondary = [defaults boolForKey:@"include_secondary"];
	BOOL includePrimary = [defaults boolForKey:@"include_primary"];
	
	baseColors = [[NSMutableArray alloc] initWithCapacity:12];
	addColors = [[NSMutableArray alloc] initWithCapacity:5];

	//Cyan
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includePrimary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
	
	//Blue
	colorComponents[1] = 1.0;
//
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includeSecondary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
 /**/	
	//Magenta
	colorComponents[0] = 0.0;
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includePrimary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
/**/
	//Red
	colorComponents[2] = 1.0;
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includeSecondary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
/**/
	//Yellow
	colorComponents[1] = 0.0;
	colorComponents[2] = 1.0;
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includePrimary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
//
	//Green
	colorComponents[0] = 1.0;
	c = CGColorCreate(s, colorComponents);
	[baseColors addObject:[UIColor colorWithCGColor:c]];
	if (includeSecondary)
		[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
	
	/**///Black
	colorComponents[0] = 0.0;
	colorComponents[1] = 0.0;
	colorComponents[2] = 0.0;
	colorComponents[3] = 1.0;
	c = CGColorCreate(s, colorComponents);
	[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
	
	/**///White
	colorComponents[0] = 0.0;
	colorComponents[1] = 0.0;
	colorComponents[2] = 0.0;
	colorComponents[3] = 0.0;
	c = CGColorCreate(s, colorComponents);
	[(NSMutableArray *)addColors addObject:[UIColor colorWithCGColor:c]];
	CGColorRelease(c);
	/**/
	CGColorSpaceRelease(s);
	
	baseColorIndex = 0;
	addColorIndex = 1;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	[(PhiColorWheelLayer *)self.layer setBaseColor:[baseColors[baseColorIndex] CGColor]];
	[(PhiColorWheelLayer *)self.layer setAddColor:[addColors[addColorIndex] CGColor]];
	[CATransaction commit];
}
- (void)setupGestureRecognizers {
	PhiColorWheelSegmentSlideGestureRecognizer *slider = [[PhiColorWheelSegmentSlideGestureRecognizer alloc] initWithTarget:self action:@selector(slideStrength:)];
	slider.segment = @"strength";
	[self addGestureRecognizer:slider];
	
	PhiColorWheelSegmentDoubleTapGestureRecognizer *dTap = [[PhiColorWheelSegmentDoubleTapGestureRecognizer alloc] initWithTarget:self action:@selector(promoteColor:)];
	dTap.segment = @"strength";
	dTap.numberOfTapsRequired = 2;
	[self addGestureRecognizer:dTap];
	
	PhiColorWheelSegmentFlickGestureRecognizer *flick;
	flick = [[PhiColorWheelSegmentFlickGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
	flick.segment = @"baseColor";
	flick.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:flick];

	flick = [[PhiColorWheelSegmentFlickGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
	flick.segment = @"baseColor";
	flick.direction = UISwipeGestureRecognizerDirectionLeft;
	[self addGestureRecognizer:flick];
	
	flick = [[PhiColorWheelSegmentFlickGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
	flick.segment = @"addColor";
	flick.direction = UISwipeGestureRecognizerDirectionLeft;
	[self addGestureRecognizer:flick];

	flick = [[PhiColorWheelSegmentFlickGestureRecognizer alloc] initWithTarget:self action:@selector(flick:)];
	flick.segment = @"addColor";
	flick.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:flick];
}

- (void)slideStrength:(UIPanGestureRecognizer *)slide {
	[(PhiColorWheelLayer *)[self layer] translateSegment:@"strength" by:[slide translationInView:self] inLayer:[self layer]];
	[slide setTranslation:CGPointZero inView:self];
	if ([self.delegate respondsToSelector:@selector(colorDidChange:)]) {
		[self.delegate performSelector:@selector(colorDidChange:) withObject:self];
	}
}

- (CGColorRef)colorForSegment:(NSString *)segment inDirection:(UISwipeGestureRecognizerDirection)direction {
	CGColorRef nextColor = NULL;
	NSInteger index = 0;
	
	if (direction == UISwipeGestureRecognizerDirectionLeft) {
		index = 1;
	} else if (direction == UISwipeGestureRecognizerDirectionRight) {
		index = -1;
	}
	
	if ([segment isEqualToString:@"baseColor"]) {
		index += baseColorIndex;
		if (index >= (NSInteger)[baseColors count])
			index -= [baseColors count];
		else if (index < 0)
			index += [baseColors count];
		baseColorIndex = index;
		nextColor = [baseColors[index] CGColor];
	} else if ([segment isEqualToString:@"addColor"]) {
		index += addColorIndex;
		if (index >= (NSInteger)[addColors count])
			index -= [addColors count];
		else if (index < 0)
			index += [addColors count];
		addColorIndex = index;
		nextColor = [addColors[index] CGColor];
	}
	
	return nextColor;
}

- (void)flick:(PhiColorWheelSegmentFlickGestureRecognizer *)flick {
	if (flick.direction & (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)) {
		//if (flick.direction == UISwipeGestureRecognizerDirectionRight) {
			PhiColorWheelWedgeSpinAnimation *a = [[PhiColorWheelWedgeSpinAnimation alloc] init];
			a.direction = flick.direction;
			a.removedOnCompletion = NO;
			a.toValue = [self colorForSegment:flick.segment inDirection:flick.direction];
			a.delegate = self;
			[a runActionForKey:flick.segment object:self.layer arguments:nil];
			//[self.layer addAnimation:a forKey:flick.segment];
		//} else
			//[self.layer setValue:[self colorForSegment:flick.segment inDirection:flick.direction] forKey:flick.segment];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag && [self.delegate respondsToSelector:@selector(colorDidChange:)]) {
		[self.delegate performSelector:@selector(colorDidChange:) withObject:self];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	return [(PhiColorWheelLayer *)[self layer] containsPoint:point inSegment:nil inLayer:[self layer]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if (![(PhiColorWheelLayer *)[self layer] containsPoint:point inSegment:nil inLayer:[self layer]]) {
		PhiColorWheelController *wheel = [PhiColorWheelController sharedColorWheelController];
		if (wheel.wheelView == self)
			[wheel setWheelVisible:NO animated:YES];
	} else {
		return self;
	}
	return nil;
}

- (void)promoteColor:(PhiColorWheelSegmentDoubleTapGestureRecognizer *)tap {
	baseColorIndex = [baseColors indexOfObject:[self color]];
	if (baseColorIndex == NSNotFound) {
		baseColorIndex = [baseColors count];
		[baseColors addObject:[self color]];
		[self.layer setValue:(id)[[baseColors lastObject] CGColor] forKey:@"baseColor"];
	} else {
		[self.layer setValue:(id)[baseColors[baseColorIndex] CGColor] forKey:@"baseColor"];
	}
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setupView];
		[self setupGestureRecognizers];
		[self setupWedgeColors];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self setupView];
		[self setupGestureRecognizers];
		[self setupWedgeColors];
    }
    return self;
}

- (UIColor *)color {
	return [UIColor colorWithCGColor:[(PhiColorWheelLayer *)[self layer] color]];
}

- (CGFloat)strength {
	return ((PhiColorWheelLayer *)self.layer).strength;
}
- (void)setStrength:(CGFloat)s {
	((PhiColorWheelLayer *)self.layer).strength = s;
}
- (UIColor *)baseColor {
	return [UIColor colorWithCGColor:((PhiColorWheelLayer *)self.layer).baseColor];
}
- (void)setBaseColor:(UIColor *)aColor {
	NSInteger index = [baseColors indexOfObject:aColor];
	if (index != NSNotFound)
		baseColorIndex = index;
	((PhiColorWheelLayer *)self.layer).baseColor = aColor.CGColor;
}
- (UIColor *)addColor {
	return [UIColor colorWithCGColor:((PhiColorWheelLayer *)self.layer).addColor];
}
- (void)setAddColor:(UIColor *)aColor {
	NSInteger index = [addColors indexOfObject:aColor];
	if (index != NSNotFound)
		addColorIndex = index;
	((PhiColorWheelLayer *)self.layer).addColor = aColor.CGColor;
}

- (void)setBaseAndAddColorForColor:(CGColorRef)color {
	if (!CGColorEqualToColor(color, [(PhiColorWheelLayer *)[self layer] color])) {
		CGFloat rgbComponents[4];
		CGColorSpaceRef space = CGColorGetColorSpace(color);
		CGColorSpaceModel model = CGColorSpaceGetModel(space);
		size_t noc = CGColorSpaceGetNumberOfComponents(space);
		CGColorRef c;
		CGFloat colorComponents[5];
		CGFloat addComponents[5];
		CGFloat baseComponents[5];
		CGFloat s = 0.0f;
		BOOL match = NO;
		int newAddColorIndex = addColorIndex;

		memcpy(colorComponents, CGColorGetComponents(color), (noc + 1) * sizeof(CGFloat));

		//NSLog(@"colorComponents:      %1.2f %1.2f %1.2f %1.2f", colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]);
		switch (model) {
			case kCGColorSpaceModelMonochrome:
			case kCGColorSpaceModelRGB:
				memcpy(rgbComponents, colorComponents, (noc + 1) * sizeof(CGFloat));

				if (model == kCGColorSpaceModelRGB) {
					colorComponents[3] = 1.0f;
					colorComponents[0] = (1.0f - rgbComponents[0]);
					colorComponents[1] = (1.0f - rgbComponents[1]);
					colorComponents[2] = (1.0f - rgbComponents[2]);
					CGFloat min = MIN(MIN(colorComponents[0], colorComponents[1]), colorComponents[2]);

					if (min >= 1.0f || (colorComponents[0] == colorComponents[1] && colorComponents[1] == colorComponents[2])) {
						colorComponents[0] = colorComponents[1] = colorComponents[2] = 0.0f;
					} else {
						colorComponents[0] = 1.0f - rgbComponents[0] / (1.0f - min);
						colorComponents[1] = 1.0f - rgbComponents[1] / (1.0f - min);
						colorComponents[2] = 1.0f - rgbComponents[2] / (1.0f - min);
					}
					colorComponents[3] = min;
				} else if (model == kCGColorSpaceModelMonochrome) {
					colorComponents[0] = colorComponents[1] = colorComponents[2] = 0.0;
					colorComponents[3] = rgbComponents[0];
				}
				colorComponents[4] = rgbComponents[noc];
			case kCGColorSpaceModelCMYK:
				noc = 4;
				model = kCGColorSpaceModelCMYK;
				if (addColorIndex == [addColors count] - 1) //Do not try white
					newAddColorIndex = --addColorIndex;
				c = [addColors[newAddColorIndex] CGColor];
				memcpy(addComponents, CGColorGetComponents(c), (noc + 1) * sizeof(CGFloat));
				memcpy(baseComponents,          addComponents, (noc + 1) * sizeof(CGFloat));
				//NSLog(@"addComponents:        %1.2f %1.2f %1.2f %1.2f %1.2f", addComponents[0], addComponents[1], addComponents[2], addComponents[3], addComponents[4]);
				if (model == CGColorSpaceGetModel(CGColorGetColorSpace(c)))
					match = [PhiColorWheelLayer computeBaseColor:baseComponents andStrength:&s fromColor:colorComponents forAddColor:(CGFloat *)CGColorGetComponents(c) model:model];
				if (!match) {
					newAddColorIndex = [addColors count] - 2; // start with black (use white as a last resort)
					do {
						if (newAddColorIndex != addColorIndex) {
							c = [addColors[newAddColorIndex] CGColor];
							if (model == CGColorSpaceGetModel(CGColorGetColorSpace(c))) {
								memcpy(addComponents, CGColorGetComponents(c), (noc + 1) * sizeof(CGFloat));
								//NSLog(@"addComponents:        %1.2f %1.2f %1.2f %1.2f %1.2f", addComponents[0], addComponents[1], addComponents[2], addComponents[3], addComponents[4]);
								if ([PhiColorWheelLayer computeBaseColor:baseComponents andStrength:&s fromColor:colorComponents forAddColor:(CGFloat *)CGColorGetComponents(c) model:model])
									break;
							}
						}
						if (--newAddColorIndex < 0)
							newAddColorIndex += [addColors count];
					} while (newAddColorIndex != [addColors count] - 2);
				}
				
				if (baseComponents[0] == 0.0 && baseComponents[1] == 0.0 && baseComponents[2] == 0.0) {
					[self setBaseColor:[UIColor colorWithCGColor:c]];
					
					c = CGColorCreate(space, baseComponents);
					addColorIndex = [addColors count] - 1; // White color
					[self setAddColor:[UIColor colorWithCGColor:c]];
					CGColorRelease(c);
					
					((PhiColorWheelLayer *)self.layer).strength = s;
				} else {
					addColorIndex = newAddColorIndex;
					((PhiColorWheelLayer *)self.layer).addColor = c;

					space = CGColorSpaceCreateDeviceCMYK();
					c = CGColorCreate(space, baseComponents);
					[self setBaseColor:[UIColor colorWithCGColor:c]];
					CGColorRelease(c);
					CGColorSpaceRelease(space);

					((PhiColorWheelLayer *)self.layer).strength = 1.0 - s;
				}

				break;
			case kCGColorSpaceModelLab:
			default:
				break;
		}
	}
}

@end
