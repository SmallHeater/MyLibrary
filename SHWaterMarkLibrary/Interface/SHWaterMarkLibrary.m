//
//  SHWaterMarkLibrary.m
//  SHWaterMarkLibrary
//
//  Created by xianjunwang on 2018/4/3.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHWaterMarkLibrary.h"
#import "WaterMarkController.h"


@implementation SHWaterMarkLibrary

//图片添加文字水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkPoint:(CGPoint)point andText:(NSString *)text andTextAttributes:(NSDictionary *)dic{
    
    UIImage * newImage = [WaterMarkController setImage:image withWaterMarkPoint:point andText:text andTextAttributes:dic];
    return newImage;
}
//图片添加图片水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkImage:(UIImage *)waterMarkImage andFrame:(CGRect)frame{
    
    UIImage * newImage = [WaterMarkController setImage:image withWaterMarkImage:waterMarkImage andFrame:frame];
    return newImage;
}

@end
