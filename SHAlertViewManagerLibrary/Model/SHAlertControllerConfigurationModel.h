//
//  SHAlertControllerConfigurationModel.h
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  UIAlertViewController的配置模型

#import <Foundation/Foundation.h>
#import "SHUIAlertActionConfigurationModel.h"


@interface SHAlertControllerConfigurationModel : NSObject

//标题
@property (nonatomic,copy) NSString * alertTitle;
//内容
@property (nonatomic,copy) NSString * alertMessage;
//样式
@property (nonatomic,assign) UIAlertControllerStyle alertControllerStyle;
//按钮模型数组
@property (nonatomic,strong) NSMutableArray<SHUIAlertActionConfigurationModel *> * actionConfigurationModelsArray;

@end
