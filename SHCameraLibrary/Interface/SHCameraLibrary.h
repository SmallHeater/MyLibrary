//
//  SHCameraLibrary.h
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHCameraLibrary : NSObject

//抓拍
+(void)snapshot:(void(^)(UIImage * image))resultBlock;

@end
