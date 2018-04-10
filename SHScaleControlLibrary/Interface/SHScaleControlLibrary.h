//
//  SHScaleControlLibrary.h
//  SHScaleControlLibrary
//
//  Created by xianjunwang on 2018/4/2.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  刻度尺组件

#import <Foundation/Foundation.h>
#import "ScaleControlConfigurationModel.h"

typedef void(^ReturnBlock)(float selectValue);

@interface SHScaleControlLibrary : NSObject


-(UIView *)getScaleControlViewWithFrame:(CGRect)frame andConfigurationModel:(ScaleControlConfigurationModel *)model andDefaultSelectValue:(NSUInteger)selectValue andBlock:(ReturnBlock)block;

//设置选中值
-(void)setSelectedValue:(CGFloat)selectedValue;

@end
