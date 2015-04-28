//
//  CLLockLabel.h
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLockLabel : UILabel



/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;



/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;


@end
