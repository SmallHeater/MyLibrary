//
//  SHNavigationBar.h
//  MyLibrary
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  自定义导航view，绿色背景,带标题，返回按钮

#import <UIKit/UIKit.h>

@interface SHNavigationBar : UIView
//标题
@property (nonatomic,strong) NSString * navTitle;
@property (nonatomic,strong) UIButton * backBtn;

//若使用本view，如果需要显示返回按钮，必须传target和SEL。
-(instancetype)initWithTitle:(NSString *)title andBackbtnAction:(SEL)action andBackBtnTarget:(id)target;
@end
