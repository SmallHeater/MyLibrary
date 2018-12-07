//
//  SHBigPictureBrowser.m
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHBigPictureBrowser.h"
#import "BigPictureBrowsing.h"

#import "BigPictureBrowsingView.h"

@implementation SHBigPictureBrowser

+(UIView *)getViewWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
//    BigPictureBrowsing * view = [[BigPictureBrowsing alloc] initWithFrame:frame andImageArray:array andSelectedIndex:index];
//    return view;
    
    BigPictureBrowsingView * view = [[BigPictureBrowsingView alloc] initWithFrame:frame andImageArray:array andSelectedIndex:index];
    return view;
}

+(UIView *)getViewWithFrame:(CGRect)frame andImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
    BigPictureBrowsing * view = [[BigPictureBrowsing alloc] initWithFrame:frame andImageURLArray:array andSelectedIndex:index];
    return view;
}

@end
