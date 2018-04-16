//
//  QRCodeBacgrouView.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeBacgrouView.h"

#define FRAMEWIDTH 233

@interface QRCodeBacgrouView()

@end

@implementation QRCodeBacgrouView

- (void)drawRect:(CGRect)rect {
    _scanFrame = CGRectMake((SCREENWIDTH - FRAMEWIDTH)/2, (SCREENHEIGHT - FRAMEWIDTH)/2, FRAMEWIDTH, FRAMEWIDTH);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充区域颜色
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65] set];
    
    //扫码区域上面填充
    CGRect notScanRect = CGRectMake(0, 0, self.frame.size.width, _scanFrame.origin.y);
    CGContextFillRect(context, notScanRect);
    
    //扫码区域左边填充
    rect = CGRectMake(0, _scanFrame.origin.y, _scanFrame.origin.x,_scanFrame.size.height);
    CGContextFillRect(context, rect);
    
    //扫码区域右边填充
    rect = CGRectMake(CGRectGetMaxX(_scanFrame), _scanFrame.origin.y, _scanFrame.origin.x,_scanFrame.size.height);
    CGContextFillRect(context, rect);

    //扫码区域下面填充
    rect = CGRectMake(0, CGRectGetMaxY(_scanFrame), self.frame.size.width,self.frame.size.height - CGRectGetMaxY(_scanFrame));
    CGContextFillRect(context, rect);

}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
