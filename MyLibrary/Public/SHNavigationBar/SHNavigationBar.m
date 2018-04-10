//
//  SHNavigationBar.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHNavigationBar.h"

@interface SHNavigationBar ()
//标题label
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation SHNavigationBar

#pragma mark  ----  生命周期函数
-(instancetype)initWithTitle:(NSString *)title andBackbtnAction:(SEL)action andBackBtnTarget:(id)target{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    if (self) {
        
        self.backgroundColor = Color_87BA4B;
        [self addSubview:self.titleLabel];
        
        self.navTitle = title;
        
        if (target) {
            
            [self.backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.backBtn];
        }
    }
    return self;
}


#pragma mark  ----  SET
-(void)setNavTitle:(NSString *)navTitle{
    
    _navTitle = navTitle;
    if (navTitle && navTitle.length > 0) {
        
        self.titleLabel.text = navTitle;
    }
}

#pragma mark  ----  懒加载

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, SCREENWIDTH - 120, 44)];
        _titleLabel.textColor = Color_FFFFFF;
        _titleLabel.font = BOLDFONT18;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
    }
    return _titleLabel;
}


-(UIButton *)backBtn{
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(0, 20, 60, 44)];
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 27);
        [_backBtn setImage:[UIImage imageNamed:@"MyLibrarySource.bundle/fanhui_w.tiff"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

@end
