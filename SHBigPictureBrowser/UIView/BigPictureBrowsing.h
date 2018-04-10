//
//  BigPictureBrowsing.h
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/6.
//  Copyright © 2017年 pk. All rights reserved.
//  大图浏览

#import <UIKit/UIKit.h>

@interface BigPictureBrowsing : UIView

-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index;

-(instancetype)initWithFrame:(CGRect)frame andImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index;

@end
