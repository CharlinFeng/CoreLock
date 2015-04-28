//
//  ViewController.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "ViewController.h"
#import "CLLockVC.h"





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 


}

-(void)lockVC{
    

}


/*
 *  设置密码
 */
- (IBAction)setPwd:(id)sender {
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    hasPwd = NO;
    if(hasPwd){
        
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    }else{
        
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}

/*
 *  验证密码
 */
- (IBAction)verifyPwd:(id)sender {
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if(!hasPwd){
        
        NSLog(@"你还没有设置密码，请先设置密码");
    }else {
        
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            NSLog(@"忘记密码");
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码正确");
            [lockVC dismiss:1.0f];
        }];
    }
}


/*
 *  修改密码
 */
- (IBAction)modifyPwd:(id)sender {
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if(!hasPwd){
        
        NSLog(@"你还没有设置密码，请先设置密码");
        
    }else {
        
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            [lockVC dismiss:.5f];
        }];
    }

}












@end
