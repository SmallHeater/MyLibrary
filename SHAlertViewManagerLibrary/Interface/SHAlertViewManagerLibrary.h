//
//  SHAlertViewManagerLibrary.h
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHAlertControllerConfigurationModel.h"

#define DELAYTIMEINTERVAL 0.5//组件内部弹出view的延时，经测试，最少需要0.5秒才可以

@interface SHAlertViewManagerLibrary : NSObject

//将需要弹出展示的view给管理类(可接收 UIView,UIAlertView,UIActionSheet,UIAlertController类型)
+(void)addShowView:(id)showView;
//将已隐藏的view从管理类中移除
+(void)deleShowView:(id)showView;
//创建alertViewController并弹出,需在响应事件里自行调用deleShowView移除
+(UIAlertController *)pushAlertControllerWithConfigurationModel:(SHAlertControllerConfigurationModel *)configurationModel;

@end
