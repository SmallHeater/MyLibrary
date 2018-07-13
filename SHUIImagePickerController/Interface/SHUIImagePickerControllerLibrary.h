//
//  SHUIImagePickerController.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  相册组件,接口类

#import <Foundation/Foundation.h>
#import "SHAssetModel.h"


@interface SHUIImagePickerControllerLibrary : NSObject
//传入允许选择的的最大图片数，回调选中的图片的模型数组
+(void)goToSHUIImagePickerViewControllerWithMaxImageSelectCount:(NSUInteger)maxCount anResultBlock:(void(^)(NSMutableArray<SHAssetModel *> * arr))result;
@end
