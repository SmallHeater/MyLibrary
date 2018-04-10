//
//  ScaleControl.h
//  ScaleDemo
//
//  Created by xianjunwang on 2018/3/20.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  刻度尺控件

#import <UIKit/UIKit.h>
#import "ScaleControlConfigurationModel.h"

@interface ScaleControl : UIControl

@property (nonatomic, assign)CGFloat selectedValue;//选中的数值
-(_Nonnull instancetype)initWithFrame:(CGRect)frame andConfigurationModel:(nonnull ScaleControlConfigurationModel *)model;

@end
