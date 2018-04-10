//
//  WaterMarkController.h
//  SHWaterMarkLibrary
//
//  Created by xianjunwang on 2018/4/3.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WaterMarkController : NSObject
//图片添加文字水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkPoint:(CGPoint)point andText:(NSString *)text andTextAttributes:(NSDictionary *)dic;
//图片添加图片水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkImage:(UIImage *)waterMarkImage andFrame:(CGRect)frame;
@end
