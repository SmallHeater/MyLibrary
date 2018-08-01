//
//  AlertViewManager.m
//  SHAlertViewManagerLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "AlertViewManager.h"
#import <UIKit/UIKit.h>
#import "SHAlertViewManagerLibrary.h"

@interface AlertViewManager ()

//存储要展示的view的数组
@property (nonatomic,strong) NSMutableArray * alertViewArray;
//是否有展示的view
@property (nonatomic,assign) BOOL hasShowView;

@end

@implementation AlertViewManager

#pragma mark  ----  自定义函数
#pragma mark  ----  添加要显示的view到数组中
-(void)addView:(id)showView{
    
    NSMutableArray * tempAlertViewArray = self.alertViewArray.mutableCopy;
    for (id view in tempAlertViewArray){
        
        if ([view isEqual:showView]){
            
            //避免同一个view被添加多次
            return;
        }
    }
    [self.alertViewArray addObject:showView];
    if (!self.hasShowView && self.alertViewArray.count > 0){
        
        //展示一个view
        id showView = self.alertViewArray[0];
        [self showFirstView:showView];
    }
}

#pragma mark  ----  从数组中移除以显示完成并消失的view
-(void)deleteView:(id)showView{
    
    NSMutableArray * tempAlertViewArray = self.alertViewArray.mutableCopy;
    for (id view in tempAlertViewArray){
        
        if ([view isEqual:showView]){
            
            if ([showView isKindOfClass:[UIView class]]){
                
                [showView removeFromSuperview];
            }
            
            self.hasShowView = NO;
            
            //从数组删除老的view，展示新的view
            [self.alertViewArray removeObject:showView];
            if (self.alertViewArray.count > 0){
                
                id showView = self.alertViewArray[0];
                NSTimer * timer = nil;
                timer = [NSTimer scheduledTimerWithTimeInterval:DELAYTIMEINTERVAL target:self selector:@selector(showNextView:) userInfo:showView repeats:NO];
            }
            break;
        }
    }
    
}

#pragma mark  ----  展示第一个view
-(void)showFirstView:(id)showView{
    
    [self showView:showView];
}

#pragma mark  ----  展示另一个view
-(void)showNextView:(NSTimer *)timer{
    
    id showView = timer.userInfo;
    [self showView:showView];
}

#pragma mark  ----  真正的展示view的方法
-(void)showView:(id)showView{
    
    self.hasShowView = YES;
    if ([showView isKindOfClass:[UIAlertView class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [(UIAlertView*)showView show];
        });
    }
    else if ([showView isKindOfClass:[UIActionSheet class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [(UIActionSheet*)showView showInView:[UIApplication sharedApplication].keyWindow];
        });
    }
    else if ([showView isKindOfClass:[UIAlertController class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[self topMostController] presentViewController:showView animated:NO completion:nil];
        });
    }
    else if ([showView isKindOfClass:[UIView class]]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication].keyWindow addSubview:showView];
        });
    }
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if ([topController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController * nav = (UINavigationController *)topController;
        topController = nav.viewControllers.lastObject;
    }
    
    return topController;
}

#pragma mark  ------  懒加载
-(NSMutableArray *)alertViewArray
{
    if (!_alertViewArray)
    {
        _alertViewArray = [[NSMutableArray alloc] init];
    }
    return _alertViewArray;
}

@end
