//
//  BPPCalendar.h
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BPPCalendar : UIView

//选中的回调日期
@property (nonatomic,copy) DataBlock block;
//显示小红点的日期
@property (nonatomic,strong) NSArray * dataArray;
@end
