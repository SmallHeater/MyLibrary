//
//  SHCalendarVC.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCalendarVC.h"
typedef void(^DataBlock)(NSUInteger year,NSUInteger month,NSUInteger day);
#import "SHCalendar.h"


@interface SHCalendarVC ()

@end

@implementation SHCalendarVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.navTitle = @"日历组件演示";
    
    DataBlock  block = ^(NSUInteger year,NSUInteger month,NSUInteger day){
        
        NSString * dateStr = [[NSString alloc] initWithFormat:@"%ld年%ld月%ld日",year,month,day];
        NSLog(@"选中日期：%@",dateStr);
    };
    
    UIView * calendarView =  [SHCalendar getCalendarViewWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) andDataArray:nil andDataBlock:block];
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
