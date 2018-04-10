//
//  SHBigPictureBrowser.h
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  大图浏览器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHBigPictureBrowser : NSObject

//本地图片
+(UIView *)getViewWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index;

//网络图片
+(UIView *)getViewWithFrame:(CGRect)frame andImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index;

@end
