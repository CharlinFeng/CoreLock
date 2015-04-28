//
//  CLLockView.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockView.h"
#import "CLLockItemView.h"
#import "CoreLockConst.h"


const CGFloat marginValue = 36.0f;


@interface CLLockView ()

/** 装itemView的可变数组*/
@property (nonatomic,strong) NSMutableArray *itemViewsM;


/** 临时密码记录器 */
@property (nonatomic,copy) NSMutableString *pwdM;


/** 设置密码：第一次设置的正确的密码 */
@property (nonatomic,copy) NSString *firstRightPWD;


/** 修改密码过程中的验证旧密码正确 */
@property (nonatomic,assign) BOOL modify_VeriryOldRight;




@end



@implementation CLLockView


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //解锁视图准备
        [self lockViewPrepare];
    }
    
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //解锁视图准备
        [self lockViewPrepare];
    }
    
    return self;
}


/*
 *  绘制线条
 */
-(void)drawRect:(CGRect)rect{
    
    //数组为空直接返回
    if(_itemViewsM == nil || _itemViewsM.count == 0) return;
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //添加圆形路径
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(CLLockItemView *itemView, NSUInteger idx, BOOL *stop) {

        CGContextAddEllipseInRect(ctx, itemView.frame);
    }];
    
    //剪裁
    CGContextEOClip(ctx);
    
    //新建路径：管理线条
    CGMutablePathRef pathM = CGPathCreateMutable();

    //设置上下文属性
    //1.设置线条颜色
    [CoreLockLockLineColor set];
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //设置线宽
    CGContextSetLineWidth(ctx, 1.0f);
    
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(CLLockItemView *itemView, NSUInteger idx, BOOL *stop) {
        
        CGPoint directPoint = itemView.center;
        
        if(idx == 0){//第一个
            
            //添加起点
            CGPathMoveToPoint(pathM, NULL, directPoint.x, directPoint.y);
            
        }else{//其他
            
            //添加路径线条
            CGPathAddLineToPoint(pathM, NULL, directPoint.x, directPoint.y);
        }
    }];

    //将路径添加到上下文
    CGContextAddPath(ctx, pathM);
    
    //渲染路径
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(pathM);
}









/*
 *  解锁视图准备
 */
-(void)lockViewPrepare{

    for (NSUInteger i=0; i<9; i++) {
        
        CLLockItemView *itemView = [[CLLockItemView alloc] init];
        
        [self addSubview:itemView];
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = (self.frame.size.width - 4 * marginValue) /3.0f;

    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = marginValue * (row +1) + row * itemViewWH;
        
        CGFloat y =marginValue * (col +1) + col * itemViewWH;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        //设置tag
        subview.tag = idx;
        
        subview.frame = frame;
    }];
    
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //解锁处理
    [self lockHandle:touches];
    

    if(CoreLockTypeSetPwd == _type){ // 设置密码
        //开始
        if(self.firstRightPWD == nil){//第一次输入
            
            if(_setPWBeginBlock != nil) _setPWBeginBlock();
            
        }else{//确认
            
            if(_setPWConfirmlock != nil) _setPWConfirmlock();
        }
    }else if(CoreLockTypeVeryfiPwd == _type){//验证密码
        
        //开始
        if(_verifyPWBeginBlock != nil) _verifyPWBeginBlock();
        
    }else if (CoreLockTypeModifyPwd == _type){
        
        //开始
        if(_modifyPwdBlock != nil) _modifyPwdBlock();
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //解锁处理
    [self lockHandle:touches];
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //手势结束
    [self gestureEnd];
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
 
    //手势结束
    [self gestureEnd];
}


/*
 *  手势结束
 */
-(void)gestureEnd{
    

    //设置密码检查
    if(self.pwdM.length != 0){
        [self setpwdCheck];
    }

    
    for (CLLockItemView *itemView in self.itemViewsM) {
        
        itemView.selected = NO;
        
        //清空方向
        itemView.direct = 0;
    }
    
    //清空数组所有对象
    [self.itemViewsM removeAllObjects];
    
    //再绘制
    [self setNeedsDisplay];
    
    //清空密码
    self.pwdM = nil;

}



/*
 *  设置密码检查
 */
-(void)setpwdCheck{
    
    NSUInteger count = self.itemViewsM.count;
    
    if(count < CoreLockMinItemCount){
        if(_setPWSErrorLengthTooShortBlock != nil) _setPWSErrorLengthTooShortBlock(count);
        return;
    }
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        //设置密码
        [self setpwd];
        
    }else if(CoreLockTypeVeryfiPwd == _type){//验证密码
        
        if(_verifyPwdBlock != nil) _verifyPwdBlock(self.pwdM);
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        if(!_modify_VeriryOldRight){
            
            if(_verifyPwdBlock != nil){
                _modify_VeriryOldRight = _verifyPwdBlock(self.pwdM);
            }
            
        }else{
            
            //设置密码
            [self setpwd];
        }
    }
    
}




/*
 *  设置密码
 */
-(void)setpwd{
    
    //密码合法
    if(self.firstRightPWD == nil){// 第一次设置密码
        self.firstRightPWD = self.pwdM;
        if(_setPWFirstRightBlock != nil) _setPWFirstRightBlock();
    }else{
        
        if(![self.firstRightPWD isEqualToString:self.pwdM]){//两次密码不一致
            
            if(_setPWSErrorTwiceDiffBlock != nil) _setPWSErrorTwiceDiffBlock(self.firstRightPWD,self.pwdM);
            return;
            
        }else{//再次密码输入一致
            
            if(_setPWTwiceSameBlock != nil) _setPWTwiceSameBlock(self.firstRightPWD);
        }
    }

}











/*
 *  解锁处理
 */
-(void)lockHandle:(NSSet *)touches{
    
    //取出触摸点
    UITouch *touch = [touches anyObject];
    
    CGPoint loc = [touch locationInView:self];
    
    CLLockItemView *itemView = [self itemViewWithTouchLocation:loc];
    
    //如果为空，返回
    if(itemView ==nil) return;
    
    //如果已经存在，返回
    if([self.itemViewsM containsObject:itemView]) return;
    
    //添加
    [self.itemViewsM addObject:itemView];
    
    //记录密码
    [self.pwdM appendFormat:@"%@",@(itemView.tag)];
    
    
    //计算方向：每添加一次itemView就计算一次
    [self calDirect];
    
    //item处理
    [self itemHandel:itemView];
}



/*
 *  计算方向：每添加一次itemView就计算一次
 */
-(void)calDirect{
    
    NSUInteger count = _itemViewsM.count;
    
    if(_itemViewsM==nil || count<=1) return;
    
    //取出最后一个对象
    CLLockItemView *last_1_ItemView = _itemViewsM.lastObject;
    
    //倒数第二个
    CLLockItemView *last_2_ItemView =_itemViewsM[count -2];
    
    //计算倒数第二个的位置
    CGFloat last_1_x = last_1_ItemView.frame.origin.x;
    CGFloat last_1_y = last_1_ItemView.frame.origin.y;
    CGFloat last_2_x = last_2_ItemView.frame.origin.x;
    CGFloat last_2_y = last_2_ItemView.frame.origin.y;
    
    //倒数第一个itemView相对倒数第二个itemView来说
    //正上
    if(last_2_x == last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecTop;
    }
    
    //正左
    if(last_2_y == last_1_y && last_2_x > last_1_x) {
        last_2_ItemView.direct = LockItemViewDirecLeft;
    }
    
    //正下
    if(last_2_x == last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecBottom;
    }
    
    //正右
    if(last_2_y == last_1_y && last_2_x < last_1_x) {
        last_2_ItemView.direct = LockItemViewDirecRight;
    }
    
    //左上
    if(last_2_x > last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecLeftTop;
    }
    
    //右上
    if(last_2_x < last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecRightTop;
    }
    
    //左下
    if(last_2_x > last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecLeftBottom;
    }
    
    //右下
    if(last_2_x < last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDiretRightBottom;
    }
    
}








/*
 *  item处理
 */
-(void)itemHandel:(CLLockItemView *)itemView{
    
    //选中
    itemView.selected = YES;
    
    //绘制
    [self setNeedsDisplay];
}



-(CLLockItemView *)itemViewWithTouchLocation:(CGPoint)loc{
    
    CLLockItemView *itemView = nil;
    
    for (CLLockItemView *itemViewSub in self.subviews) {
        
        if(!CGRectContainsPoint(itemViewSub.frame, loc)) continue;
        itemView = itemViewSub;
        break;
    }
    
    return itemView;
}




-(NSMutableArray *)itemViewsM{
    
    if(_itemViewsM == nil){
        
        _itemViewsM = [NSMutableArray array];
    }
    
    return _itemViewsM;
}


-(NSMutableString *)pwdM{
    
    if(_pwdM == nil){
        
        _pwdM = [NSMutableString string];
    }
    
    return _pwdM;
}


/*
 *  重设密码
 */
-(void)resetPwd{
    
    //清空第一次密码即可
    self.firstRightPWD = nil;
}

@end
