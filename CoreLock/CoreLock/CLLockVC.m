//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CoreArchive.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"



@interface CLLockVC ()

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;


@property (nonatomic,copy) NSString *modifyCurrentTitle;


@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;



/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;



@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
}


/*
 *  事件
 */
-(void)event{
    
    
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
      
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        
        //存储密码
        [CoreArchive setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
        if(_successBlock != nil) _successBlock(self,pwd);
        
        if(CoreLockTypeModifyPwd == _type){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
        //取出本地密码
        NSString *pwdLocal = [CoreArchive strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if(CoreLockTypeVeryfiPwd == _type){
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }else if (CoreLockTypeModifyPwd == _type){//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type) {
                if(_successBlock != nil) _successBlock(self,pwd);
            }
            
        }else{//密码不一致
            
            [self.label showWarnMsg:CoreLockVerifyErrorPwdTitle];

        }
        
        return res;
    };
    
    
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
    
}






/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}







/*
 *  控制器准备
 */
-(void)vcPrepare{

    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeModifyPwd == _type) {
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];

        if(_isDirectModify) return;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    if(![self.class hasPwd]){
        [_modifyBtn removeFromSuperview];
    }
}

-(void)dismiss{
    [self dismiss:0];
}



/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}



/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}








/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    
    return pwd !=nil;
}




/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;
    
    return lockVC;
}





+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}



-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}



/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}




/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}


- (IBAction)forgetPwdAction:(id)sender {

    [self dismiss:0];
    if(_forgetPwdBlock != nil) _forgetPwdBlock();
}


- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}












@end
