//
//  CLLockMainView.m
//  CoreLock
//
//  Created by 冯成林 on 15/4/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockMainView.h"
#import "CoreConst.h"


@interface CLLockMainView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginC;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewTopMoveC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopMarginC;


@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;



@end



@implementation CLLockMainView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    if(iphone4x_3_5){
        
        _topC.constant =30;
        
        _bottomMarginC.constant = -30;
        
        _infoViewTopMoveC.constant = -10;
        
        _labelTopMarginC.constant = 10;
    }
}



-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if(iphone4x_3_5){
        
        CGRect forgetFrame = [_forgetBtn convertRect:_forgetBtn.bounds toView:self];
        
        CGRect modifyFrame = [_modifyBtn convertRect:_modifyBtn.bounds toView:self];
        
        if(CGRectContainsPoint(forgetFrame, point)) return _forgetBtn;
        if(CGRectContainsPoint(modifyFrame, point)) return _modifyBtn;
    }

    return [super hitTest:point withEvent:event];
}


@end
