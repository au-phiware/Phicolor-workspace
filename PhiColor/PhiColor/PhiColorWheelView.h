//
//  ColorWheelView.h
//  ColorWheel
//
//  Created by Corin Lawson on 23/06/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

@interface PhiColorWheelSegmentSlideGestureRecognizer : UIPanGestureRecognizer
{
	NSString *segment;
}

@property(strong, nonatomic) NSString * segment;

@end

@interface PhiColorWheelSegmentFlickGestureRecognizer : UISwipeGestureRecognizer
{
	NSString *segment;
}

@property(strong, nonatomic) NSString * segment;

@end

@interface PhiColorWheelSegmentDoubleTapGestureRecognizer : UITapGestureRecognizer
{
	NSString *segment;
}

@property(strong, nonatomic) NSString * segment;

@end


@interface PhiColorWheelView : UIView {
	NSMutableArray *baseColors;
	NSArray *addColors;
	NSInteger baseColorIndex;
	NSInteger addColorIndex;
	
	id __weak delegate;
}

@property (nonatomic, weak) id delegate;

@property(strong, nonatomic) UIColor *baseColor;
@property(strong, nonatomic) UIColor *addColor;
@property(nonatomic) CGFloat strength;
- (UIColor *)color;

- (void)setBaseAndAddColorForColor:(CGColorRef)color;

@end

