//
//  SHQRCodeLibrary.h
//  SHQRCodeLibrary
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  扫一扫组件

#import <Foundation/Foundation.h>

@interface SHQRCodeLibrary : NSObject

//得到扫描结果
+(void)scanBlock:(void(^)(NSString *))resultBlock;

@end
