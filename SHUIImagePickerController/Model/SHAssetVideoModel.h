//
//  SHAssetVideoModel.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2018/7/20.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  视频模型

#import <Foundation/Foundation.h>
#import "SHAssetBaseModel.h"


@interface SHAssetVideoModel : SHAssetBaseModel

//路径
@property (nonatomic,strong) NSURL * videoUrl;

@property (nonatomic,strong) NSString * filename;
//大小
@property (nonatomic,assign) long long size;

@end
