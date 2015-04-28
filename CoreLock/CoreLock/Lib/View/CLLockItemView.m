//
//  CLLockItemView.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockItemView.h"
#import "CoreLockConst.h"

@interface CLLockItemView ()

/** 圆环rect */
@property (nonatomic,assign) CGRect calRect;

/** 选中的rect */
@property (nonatomic,assign) CGRect selectedRect;

/** 角度 */
@property (nonatomic,assign) CGFloat angle;

@end


@implementation CLLockItemView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
         self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}



-(void)drawRect:(CGRect)rect{
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //上下文旋转
    [self transFormCtx:ctx rect:rect];
    
    //上下文属性设置
    [self propertySetting:ctx];
    
    //外环：普通
    [self circleNormal:ctx rect:rect];
    
    //选中情况下，绘制背景色
    if(_selected){
        
        //外环：选中
        [self circleSelected:ctx rect:rect];
        
        //三角形：方向标识
        [self directFlag:ctx rect:rect];
    }
    

}


/*
 *  上下文旋转
 */
-(void)transFormCtx:(CGContextRef)ctx rect:(CGRect)rect{
    
    if(self.direct == 0) return;
    
    CGFloat translateXY = rect.size.width * .5f;
    
    //平移
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    
    CGContextRotateCTM(ctx, self.angle);
    
    //再平移回来
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}



/*
 *  三角形：方向标识
 */
-(void)directFlag:(CGContextRef)ctx rect:(CGRect)rect{
    
    if(self.direct == 0) return;
    
    //新建路径：三角形
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    
    CGFloat marginSelectedCirclev = 4.0f;
    CGFloat w =8.0f;
    CGFloat h =5.0f;
    CGFloat topX = rect.origin.x + rect.size.width * .5f;
    CGFloat topY = rect.origin.y +(rect.size.width *.5f - h - marginSelectedCirclev - self.selectedRect.size.height *.5f);
    
    CGPathMoveToPoint(trianglePathM, NULL, topX, topY);
    
    //添加左边点
    CGFloat leftPointX = topX - w *.5f;
    CGFloat leftPointY =topY + h;
    CGPathAddLineToPoint(trianglePathM, NULL, leftPointX, leftPointY);
    
    //右边的点
    CGFloat rightPointX = topX + w *.5f;
    CGPathAddLineToPoint(trianglePathM, NULL, rightPointX, leftPointY);

    //将路径添加到上下文中
    CGContextAddPath(ctx, trianglePathM);
    
    //绘制圆环
    CGContextFillPath(ctx);
    
    //释放路径
    CGPathRelease(trianglePathM);
}




/*
 *  上下文属性设置
 */
-(void)propertySetting:(CGContextRef)ctx{
    
    //设置线宽
    CGContextSetLineWidth(ctx, CoreLockArcLineW);
    
    //设置颜色
    UIColor *color = nil;
    if(_selected){
        
        color = CoreLockCircleLineSelectedColor;
    }else{
        color = CoreLockCircleLineNormalColor;
    }
    [color set];
}



/*
 *  外环：普通
 */
-(void)circleNormal:(CGContextRef)ctx rect:(CGRect)rect{
    
    //新建路径：外环
    CGMutablePathRef loopPath = CGPathCreateMutable();
    
    //添加一个圆环路径
    CGRect calRect = self.calRect;
    CGPathAddEllipseInRect(loopPath, NULL, calRect);
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, loopPath);
    
    //绘制圆环
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(loopPath);
}


/*
 *  外环：选中
 */
-(void)circleSelected:(CGContextRef)ctx rect:(CGRect)rect{
    
    //新建路径：外环
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    //绘制一个圆形
    CGPathAddEllipseInRect(circlePath, NULL, self.selectedRect);
    
    [CoreLockCircleLineSelectedCircleColor set];
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, circlePath);
    
    //绘制圆环
    CGContextFillPath(ctx);
    
    //释放路径
    CGPathRelease(circlePath);
}






-(void)setSelected:(BOOL)selected{
    
    _selected = selected;
    
    [self setNeedsDisplay];
}


-(CGRect)calRect{
    
    if(CGRectEqualToRect(_calRect, CGRectZero)){
        
        CGFloat lineW =CoreLockArcLineW;
        
        CGFloat sizeWH = self.bounds.size.width - lineW;
        CGFloat originXY = lineW *.5f;
        
        //添加一个圆环路径
        _calRect = (CGRect){CGPointMake(originXY, originXY),CGSizeMake(sizeWH, sizeWH)};
        
    }
    
    return _calRect;
}



-(CGRect)selectedRect{
    
    if(CGRectEqualToRect(_selectedRect, CGRectZero)){
        
        CGRect rect = self.bounds;
        
        CGFloat selectRectWH = rect.size.width * CoreLockArcWHR;
        
        CGFloat selectRectXY = rect.size.width * (1 - CoreLockArcWHR) *.5f;
        
        _selectedRect = CGRectMake(selectRectXY, selectRectXY, selectRectWH, selectRectWH);
    }
    
    return _selectedRect;
}

-(void)setDirect:(LockItemViewDirect)direct{
    
    _direct = direct;
    
    self.angle = M_PI_4 * (direct -1);
    
    [self setNeedsDisplay];
}


@end
