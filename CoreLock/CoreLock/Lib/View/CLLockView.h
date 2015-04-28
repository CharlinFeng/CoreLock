//
//  CLLockView.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLLockVC.h"

@interface CLLockView : UIView

@property (nonatomic,assign) CoreLockType type;



/*
 *  设置密码
 */

/** 开始输入，第一次 */
@property (nonatomic,copy) void (^setPWBeginBlock)();

/** 开始输入，确认密码*/
@property (nonatomic,copy) void (^setPWConfirmlock)();


/** 设置密码出错：长度不够 */
@property (nonatomic,copy) void (^setPWSErrorLengthTooShortBlock)(NSUInteger currentCount);


/** 设置密码出错：再次密码不一致 */
@property (nonatomic,copy) void (^setPWSErrorTwiceDiffBlock)(NSString *pwd1,NSString *pwdNow);


/** 设置密码：第一次输入正确*/
@property (nonatomic,copy) void (^setPWFirstRightBlock)();


/** 再次密码输入一致 */
@property (nonatomic,copy) void (^setPWTwiceSameBlock)(NSString *pwd);


/*
 *  重设密码
 */
-(void)resetPwd;


/*
 *  验证密码
 */

/** 验证密码开始*/
@property (nonatomic,copy) void (^verifyPWBeginBlock)();

/** 验证密码 */
@property (nonatomic,copy) BOOL (^verifyPwdBlock)(NSString *pwd);


/*
 *  修改密码
 */
/** 再次密码输入一致 */
@property (nonatomic,copy) void (^modifyPwdBlock)();


/** 密码修改成功 */
@property (nonatomic,copy) void (^modifyPwdSuccessBlock)();




@end
