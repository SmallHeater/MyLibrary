//
//  SHAssetModel.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  图片模型

#import <Foundation/Foundation.h>
#import "SHAssetBaseModel.h"


@class PHAsset;

@interface SHAssetImageModel : SHAssetBaseModel

/**
 *  PHAsset
 */
@property (nonatomic, strong,nonnull) PHAsset *asset;

/**
 *  原图 (默认尺寸kOriginTargetSize)
 */
@property (nonatomic, strong,nonnull) UIImage * originalImage;

/**
 *  预览图（默认尺寸kPreviewTargetSize）
 */
@property (nonatomic, strong, readonly, nonnull) UIImage * previewImage;



/**
 *  初始化相片model
 *
 *  @param asset PHAsset/ALAsset
 *
 *  @return SYAsset
 */
- (instancetype _Nonnull)initWithAsset:(PHAsset * _Nonnull)asset;


@end
