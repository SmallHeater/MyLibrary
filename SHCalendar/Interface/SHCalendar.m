//
//  SHCalendar.m
//  SHCalendar
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCalendar.h"
#import "BPPCalendar.h"


@implementation SHCalendar

+(UIView *)getCalendarViewWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray andDataBlock:(DataBlock)block{
    
    BPPCalendar *calendarView = [[BPPCalendar alloc] initWithFrame:frame];
    calendarView.dataArray = dataArray;
    calendarView.block = block;
    return calendarView;
}

@end
