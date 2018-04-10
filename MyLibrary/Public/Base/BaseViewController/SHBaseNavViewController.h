//
//  JHBusAppleBaseViewController.h
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/7.
//  Copyright © 2017年 pk. All rights reserved.
//  带导航的viewController基类

#import "SHBaseViewController.h"
#import "SHNavigationBar.h"


@interface SHBaseNavViewController : SHBaseViewController

@property (nonatomic,strong) SHNavigationBar * navigationBar;
@property (nonatomic,strong) NSString * navTitle;
//无网效果的背景view
@property (nonatomic,strong) UIView * noInternetBGView;


- (void)backBtnClicked:(UIButton *)btn;

@end
