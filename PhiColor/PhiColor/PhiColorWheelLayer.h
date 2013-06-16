//
//  ColorWheelLayer.h
//  ColorWheel
//
//  Created by Corin Lawson on 24/06/10.
//  Copyright 2010 Corin Lawson. All rights reserved.
//

@interface PhiColorWheelLayer : CALayer {
	CGColorRef color;
	CGColorRef transitionColor;
	CGColorRef transitionBaseColor;
	CGColorRef transitionAddColor;
}

@property(nonatomic) CGColorRef baseColor;
@property(nonatomic) CGColorRef addColor;
@property(nonatomic) CGFloat strength;
@property(readonly, nonatomic) CGColorRef color;
@property(nonatomic) CGFloat wedgeMargin;
@property(nonatomic) CGFloat wedgeCornerRadius;
@property(nonatomic) CGFloat wedgeHeight;
@property(nonatomic) CGFloat wedgeWindowHeight;
@property(nonatomic) CGFloat wedgeWindowArc;
@property(nonatomic) CGFloat baseColorAngleWeight;
@property(nonatomic) CGFloat addColorAngleWeight;

+ (void)computeColor:(CGFloat *)colorComponents fromBaseColor:(CGFloat *)baseComponents withAddColor:(CGFloat *)addComponents forStrength:(CGFloat)strength model:(CGColorSpaceModel)model;
+ (BOOL)computeBaseColor:(CGFloat *)baseComponents andStrength:(CGFloat *)strength fromColor:(CGFloat *)colorComponents forAddColor:(CGFloat *)addComponents model:(CGColorSpaceModel)model;

@end
