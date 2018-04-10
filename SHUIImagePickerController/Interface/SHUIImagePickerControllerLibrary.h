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
+(void)goToSHUIImagePickerViewControllerWithMaxImageSelectCount:(NSUInteger)maxCount anResultBlock:(void(^)(NSMutableArray<SHAssetModel *> * arr))result;
@end
