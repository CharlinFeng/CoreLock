//
//  CoreLockConst.m
//  CoreLock
//
//  Created by 成林 on 15/4/24.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#ifndef _CoreLockConst_H_
#define _CoreLockConst_H_

#import <UIKit/UIKit.h>

/** 选中圆大小比例 */
const CGFloat CoreLockArcWHR = .3f;


/** 选中圆大小的线宽 */
const CGFloat CoreLockArcLineW = 1.0f;


/** 密码存储Key */
NSString *const CoreLockPWDKey = @"CoreLockPWDKey";


/*
 *  设置密码
 */


/** 最低设置密码数目 */
const NSUInteger CoreLockMinItemCount = 4;


/** 设置密码提示文字 */
NSString *const CoreLockPWDTitleFirst = @"请滑动设置新密码";



/** 设置密码提示文字：确认 */
NSString *const CoreLockPWDTitleConfirm = @"请再次输入确认密码";


/** 设置密码提示文字：再次密码不一致 */
NSString *const CoreLockPWDDiffTitle = @"再次密码输入不一致";

/** 设置密码提示文字：设置成功 */
NSString *const CoreLockPWSuccessTitle = @"密码设置成功！";


/*
 *  验证密码
 */

/** 验证密码：普通提示文字 */
NSString *const CoreLockVerifyNormalTitle = @"请滑动输入密码";


/** 验证密码：密码错误 */
NSString *const CoreLockVerifyErrorPwdTitle = @"输入密码错误";


/** 验证密码：验证成功 */
NSString *const CoreLockVerifySuccesslTitle = @"密码正确";


/*
 *  修改密码
 */
/** 修改密码：普通提示文字 */
NSString *const CoreLockModifyNormalTitle = @"请输入旧密码";




#endif