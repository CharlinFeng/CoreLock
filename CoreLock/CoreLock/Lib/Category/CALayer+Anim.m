//
//  CALayer+Anim.m
//  CoreLock
//
//  Created by 冯成林 on 15/4/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CALayer+Anim.h"

@implementation CALayer (Anim)


/*
 *  摇动
 */
-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 16;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .1f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
