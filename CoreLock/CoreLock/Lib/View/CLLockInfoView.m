//
//  CLLockInfoView.m
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockInfoView.h"
#import "CoreLockConst.h"





@implementation CLLockInfoView {
	NSString *password;
}

- (void)redrawRect:(CGRect)rect path:(CGMutablePathRef)pathM {
		//获取上下文
	CGContextRef ctx = UIGraphicsGetCurrentContext();

		//设置属性
	CGContextSetLineWidth(ctx, CoreLockArcLineW);

		//添加路径
	CGContextAddPath(ctx, pathM);

		//绘制路径
	CGContextStrokePath(ctx);

		//释放路径
	CGPathRelease(pathM);
}

FOUNDATION_STATIC_INLINE CGMutablePathRef path(CGMutablePathRef pathM, NSUInteger i, CGFloat rectWH, CGFloat padding, CGFloat marginV) {
	NSUInteger row = i % 3;
	NSUInteger col = i / 3;

	CGFloat rectX = (rectWH + marginV) * row + padding;

	CGFloat rectY = (rectWH + marginV) * col + padding;

	CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);

	CGPathAddEllipseInRect(pathM, NULL, rect);

	return pathM;
}

- (CGMutablePathRef)plainPathWithRectWH:(CGFloat)rectWH marginV:(CGFloat)marginV padding:(CGFloat)padding {
	CGMutablePathRef pathM =CGPathCreateMutable();
	for (NSUInteger i=0; i<9; i++) {

		if (!password.length || [password rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)i]].location == NSNotFound) {
			path(pathM, i, rectWH, padding, marginV);

			[CoreLockCircleLineNormalColor set];
		}
	}

	return pathM;
}

- (CGMutablePathRef)highlightpathWithRectWH:(CGFloat)rectWH marginV:(CGFloat)marginV padding:(CGFloat)padding {
	CGMutablePathRef pathM =CGPathCreateMutable();
	for (NSUInteger i=0; i<9; i++) {

		if (password.length && [password rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)i]].location != NSNotFound) {
			path(pathM, i, rectWH, padding, marginV);

			[CoreLockCircleLineSelectedColor set];
		}

	}
	
	return pathM;
}

-(void)drawRect:(CGRect)rect{
	[super drawRect:rect];

	CGFloat marginV = 3.f;
	CGFloat padding = 1.0f;
	CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;

	[self redrawRect:rect path:[self plainPathWithRectWH:rectWH marginV:marginV padding:padding]];
	[self redrawRect:rect path:[self highlightpathWithRectWH:rectWH marginV:marginV padding:padding]];
}



- (void)redraw:(NSNotification *)notif {
	password = notif.userInfo[@"CLLockView"];
	[self setNeedsDisplay];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redraw:) name:@"CLLockView" object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
















@end
