//
//  SHAlertViewManagerLibrary.m
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHAlertViewManagerLibrary.h"
#import "AlertViewManager.h"
#import "MBProgressHUD.h"

@interface SHAlertViewManagerLibrary ()

@property (nonatomic,strong) AlertViewManager * manager;

@end

@implementation SHAlertViewManagerLibrary

#pragma mark  ----  生命周期函数
+(SHAlertViewManagerLibrary *)sharedManager{
    
    static SHAlertViewManagerLibrary * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SHAlertViewManagerLibrary alloc] init];
    });
    return manager;
}

#pragma mark  ----  自定义函数

//将需要弹出展示的view给管理类(可接收 UIView,UIAlertView,UIAlertController,UIViewController类型)
+(void)addShowView:(id)showView{
    
    if (showView && ([showView isKindOfClass:[UIView class]] || [showView isKindOfClass:[UIAlertView  class]] || [showView isKindOfClass:[UIAlertController class]] || [showView isKindOfClass:[UIActionSheet class]])){
        
        [[SHAlertViewManagerLibrary sharedManager].manager addView:showView];
    }
    else{
        
        [MBProgressHUD displayHudError:@"不支持此种类型"];
    }
}

//将已隐藏的view从管理类中移除
+(void)deleShowView:(id)showView{
    
    if (showView && ([showView isKindOfClass:[UIView class]] || [showView isKindOfClass:[UIAlertView  class]] || [showView isKindOfClass:[UIAlertController class]] || [showView isKindOfClass:[UIActionSheet class]])){
        
        [[SHAlertViewManagerLibrary sharedManager].manager deleteView:showView];
    }
    else{
        
        [MBProgressHUD displayHudError:@"不支持此种类型"];
    }
}

//创建alertViewController并弹出
+(UIAlertController *)pushAlertControllerWithConfigurationModel:(SHAlertControllerConfigurationModel *)configurationModel{
    
    NSString * alertTitle;
    if (configurationModel.alertTitle) {
        
        alertTitle = configurationModel.alertTitle;
    }
    else{
        
        alertTitle = @"";
    }
    
    NSString * alertMessage;
    if (configurationModel.alertMessage) {
        
        alertMessage = configurationModel.alertMessage;
    }
    else{
        
        alertMessage  =@"";
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:configurationModel.alertControllerStyle];
    
    for (NSUInteger i = 0; i < configurationModel.actionConfigurationModelsArray.count; i++) {
        
        SHUIAlertActionConfigurationModel * actionConfigurationModel = configurationModel.actionConfigurationModelsArray[i];
        
        NSString * actionTitle;
        if (actionConfigurationModel.alertActionTitle) {
            
            actionTitle = actionConfigurationModel.alertActionTitle;
        }
        else{
            
            actionTitle = @"";
        }
        
        UIAlertActionStyle alertActionStyle;
        if (actionConfigurationModel.actionStyle) {
            
            alertActionStyle = actionConfigurationModel.actionStyle;
        }
        else{
            
            alertActionStyle = UIAlertActionStyleDefault;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:actionTitle style:alertActionStyle handler:actionConfigurationModel.actionBlock];
        [alertController addAction:action];
    }
    
    [SHAlertViewManagerLibrary addShowView:alertController];
    return alertController;
}

#pragma mark  ----  懒加载
-(AlertViewManager *)manager
{
    if (!_manager)
    {
        _manager = [[AlertViewManager alloc] init];
    }
    return _manager;
}

@end
