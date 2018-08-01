//
//  SHUIImagePickerController.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  相册组件,接口类

#import <Foundation/Foundation.h>
#import "SHAssetBaseModel.h"
#import "SHAssetImageModel.h"
#import "SHAssetVideoModel.h"

//资源类型
typedef NS_ENUM(NSInteger, SourceType) {
    
    SourceImage   = 0,
    SourceVideo   = 1,
    SourceAudio   = 2
};

@interface SHUIImagePickerControllerLibrary : NSObject
//传入允许选择的的最大图片数或者最大视频数，回调选中的图片或视频的模型数组
+(void)goToSHUIImagePickerViewControllerWithMaxImageSelectCount:(NSUInteger)maxCount sourceType:(SourceType)type anResultBlock:(void(^)(NSMutableArray<SHAssetBaseModel *> * arr))result;
@end
