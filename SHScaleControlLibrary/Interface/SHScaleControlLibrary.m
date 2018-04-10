//
//  SHScaleControlLibrary.m
//  SHScaleControlLibrary
//
//  Created by xianjunwang on 2018/4/2.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHScaleControlLibrary.h"
#import "ScaleControl.h"

@interface SHScaleControlLibrary()

@property (nonatomic,copy) ReturnBlock block;
//刻度尺
@property (nonatomic,strong) ScaleControl * ruler;

@end

@implementation SHScaleControlLibrary

#pragma mark  ----  生命周期函数

#pragma mark  ----  自定义函数

-(UIView *)getScaleControlViewWithFrame:(CGRect)frame andConfigurationModel:(ScaleControlConfigurationModel *)model andDefaultSelectValue:(NSUInteger)selectValue andBlock:(ReturnBlock)block{
    
    self.ruler = [[ScaleControl alloc] initWithFrame:frame andConfigurationModel:model];
    self.ruler.selectedValue = selectValue;// 设置默认值
    
    if (block) {
        
        self.block = block;
    }
    //每个小格格大值计算为：ruler.valueStep÷(ruler.midCount*ruler.smallCount)
    [self.ruler addTarget:self action:@selector(selectedValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听方法
    return self.ruler;
}

- (void)selectedValueChanged:(ScaleControl *)ruler {
    
    if (self.block) {
        
        self.block(self.ruler.selectedValue);
    }
}

-(void)setSelectedValue:(CGFloat)selectedValue{
    
    self.ruler.selectedValue = selectedValue;
}

@end
