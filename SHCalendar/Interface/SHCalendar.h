//
//  SHCalendar.h
//  SHCalendar
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHCalendar : NSObject

+(UIView *)getCalendarViewWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray andDataBlock:(DataBlock)block;

@end
