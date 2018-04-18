//
//  SHCameraLibrary.m
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCameraLibrary.h"
#import "SHCameraVC.h"


@implementation SHCameraLibrary

//抓拍
+(void)snapshot:(void(^)(UIImage * image))resultBlock{
    
    SHCameraVC * cameraVC = [[SHCameraVC alloc] init];
    cameraVC.returnBlock = resultBlock;
    [[self currentViewController] presentViewController:cameraVC animated:YES completion:nil];
}

+ (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}
@end
