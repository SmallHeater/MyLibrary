//
//  BPPCalendarCell.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendarCell.h"

@interface BPPCalendarCell ()
@property (nonatomic,strong) UIImageView * pointImageView;
@end

@implementation BPPCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.5, 0, self.bounds.size.width - 5, self.bounds.size.height - 5)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.pointImageView];
}

#pragma mark  ----  SET
-(void)setShowPoint:(BOOL)showPoint{
    
    if (showPoint) {
        
        self.pointImageView.hidden = NO;
    }
    else{
        
        self.pointImageView.hidden = YES;
    }
}

#pragma mark  ----  懒加载
-(UIImageView *)pointImageView{
    
    if (!_pointImageView) {
        
        _pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 4) / 2, self.bounds.size.height - 10, 4, 4)];
        _pointImageView.backgroundColor = [UIColor grayColor];
    }
    return _pointImageView;
}

@end
