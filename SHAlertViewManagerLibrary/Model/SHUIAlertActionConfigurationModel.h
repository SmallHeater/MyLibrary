//
//  SHUIAlertActionConfigurationModel.h
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  UIAlertViewController按钮的配置模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AlertActionBlock)(UIAlertAction *action);

@interface SHUIAlertActionConfigurationModel : NSObject

//按钮标题
@property (nonatomic,copy) NSString * alertActionTitle;
//样式
@property (nonatomic,assign) UIAlertActionStyle actionStyle;
//响应事件
@property (nonatomic,copy) AlertActionBlock actionBlock;

@end
