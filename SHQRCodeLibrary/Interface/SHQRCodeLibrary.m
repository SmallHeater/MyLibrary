//
//  SHQRCodeLibrary.m
//  SHQRCodeLibrary
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHQRCodeLibrary.h"
#import "QRCodeVC.h"


@implementation SHQRCodeLibrary

//得到扫描结果
+(void)scanBlock:(void(^)(NSString *))resultBlock{
    
    QRCodeVC * qrCodeVC = [[QRCodeVC alloc] init];
    qrCodeVC.resuatBlock = resultBlock;
    [[self currentViewController] presentViewController:qrCodeVC animated:YES completion:^{
        
    }];
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
