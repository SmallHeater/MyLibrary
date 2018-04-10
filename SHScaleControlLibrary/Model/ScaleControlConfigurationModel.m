//
//  ScaleControlConfigurationModel.m
//  ScaleDemo
//
//  Created by xianjunwang on 2018/3/29.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "ScaleControlConfigurationModel.h"

#define kMinorScaleDefaultSpacing   20    // 小刻度间距
#define kRulerDefaultBackgroundColor    ([UIColor clearColor])  //刻度尺背景颜色
#define kScaleDefaultColor          ([UIColor lightGrayColor])  //刻度颜色
#define kScaleDefaultFontColor      ([UIColor darkGrayColor])  //刻度字体颜色
#define kIndicatorDefaultColor      ([UIColor redColor])  //指示器默认颜色

@implementation ScaleControlConfigurationModel

#pragma mark  ----  懒加载

//小刻度间距
- (CGFloat)minorScaleSpacing {
    
    if (_minorScaleSpacing <= 0) {
        
        _minorScaleSpacing = kMinorScaleDefaultSpacing;
    }
    return _minorScaleSpacing;
}

//刻度尺背景颜色
- (UIColor *)rulerBackgroundColor {
    
    if (_rulerBackgroundColor == nil) {
        
        _rulerBackgroundColor = kRulerDefaultBackgroundColor;
    }
    return _rulerBackgroundColor;
}

//刻度颜色
- (UIColor *)scaleColor {
    
    if (_scaleColor == nil) {
        
        _scaleColor = kScaleDefaultColor;
    }
    return _scaleColor;
}

// 刻度字体颜色
- (UIColor *)scaleFontColor {
    
    if (_scaleFontColor == nil) {
        
        _scaleFontColor = kScaleDefaultFontColor;
    }
    return _scaleFontColor;
}

//指示器颜色
- (UIColor *)indicatorColor {
    
    if (_indicatorColor == nil) {
        
        _indicatorColor = kIndicatorDefaultColor;
    }
    return _indicatorColor;
}

@end
