//
//  ScaleControlConfigurationModel.h
//  ScaleDemo
//
//  Created by xianjunwang on 2018/3/29.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  刻度尺初始化配置模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScaleControlConfigurationModel : NSObject

@property (nonatomic, assign)NSInteger minValue;//最小值
@property (nonatomic, assign)NSInteger maxValue;//最大值
@property (nonatomic, assign)NSInteger valueStep;//步长
@property (nonatomic, assign)CGFloat minorScaleSpacing;//小刻度间距，默认值 `20.0`
@property (nonatomic, assign)NSInteger midCount;//几个大格标记一个刻度
@property (nonatomic, assign)NSInteger smallCount;//一个大格里面几个小格

@property (nonatomic, strong)UIColor *rulerBackgroundColor;//刻度尺背景颜色，默认为 `clearColor`
@property (nonatomic, strong)UIColor *scaleColor;//刻度颜色，默认为 `lightGrayColor`
@property (nonatomic, strong)UIColor *scaleFontColor;// 刻度字体颜色，默认为 `darkGrayColor`
@property (nonatomic, strong)UIColor *indicatorColor;//指示器颜色，默认 `redColor`

@end
