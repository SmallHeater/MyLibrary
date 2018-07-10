//
//  SHAlertControllerConfigurationModel.m
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHAlertControllerConfigurationModel.h"

@implementation SHAlertControllerConfigurationModel

#pragma mark  ----  懒加载
-(NSMutableArray<SHUIAlertActionConfigurationModel *> *)actionConfigurationModelsArray{
    
    if (!_actionConfigurationModelsArray) {
        
        _actionConfigurationModelsArray = [[NSMutableArray alloc] init];
    }
    return _actionConfigurationModelsArray;
}

@end
