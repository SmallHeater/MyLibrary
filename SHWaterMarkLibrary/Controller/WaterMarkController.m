//
//  WaterMarkController.m
//  SHWaterMarkLibrary
//
//  Created by xianjunwang on 2018/4/3.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "WaterMarkController.h"
#import <AVFoundation/AVFoundation.h>

@implementation WaterMarkController

//图片添加文字水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkPoint:(CGPoint)point andText:(NSString *)text andTextAttributes:(NSDictionary *)dic{
    
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0,image.size.width,image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:dic];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}
//图片添加图片水印
+(UIImage *)setImage:(UIImage *)image withWaterMarkImage:(UIImage *)waterMarkImage andFrame:(CGRect)frame{
    
    UIImage *bgImage = image;
    //创建一个位图上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    //将背景图片画入位图中
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    //将水印Logo画入背景图中
    UIImage *waterIma = waterMarkImage;
    [waterIma drawInRect:frame];
    //取得位图上下文中创建的新的图片
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    //在创建的ImageView上显示出新图片
    return newimage;
}

@end
