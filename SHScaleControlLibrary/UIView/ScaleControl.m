//
//  ScaleControl.m
//  ScaleDemo
//
//  Created by xianjunwang on 2018/3/20.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "ScaleControl.h"

#define kScaleDefaultFontSize       10.0  //刻度字体

@interface ScaleControl ()<UIScrollViewDelegate>

//配置模型
@property (nonatomic,strong) ScaleControlConfigurationModel * configurationModel;

@property (nonatomic,strong) UIScrollView * scrollView;
//刻度尺
@property (nonatomic,strong) UIImageView * rulerImageView;
//指示器
@property (nonatomic,strong) UIView * indicatorView;

@property (nonatomic, assign)CGFloat indicatorLength;//指示器长度，控件高度
@property (nonatomic, assign)CGFloat majorScaleLength;//主刻度长度，控件高度的三分之一
@property (nonatomic, assign)CGFloat middleScaleLength;//中间刻度长度，控件高度的四分之一
@property (nonatomic, assign)CGFloat minorScaleLength;//小刻度长度，控件高度的五分之一
@property (nonatomic, assign)CGFloat scaleFontSize;//刻度字体尺寸，默认为 `10.0`

@end

@implementation ScaleControl

#pragma mark  ----  生命周期函数
-(instancetype)initWithFrame:(CGRect)frame andConfigurationModel:(ScaleControlConfigurationModel *)model{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (model) {
            
            self.configurationModel = model;
        }
        [self setupUI];
    }
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.rulerImageView.image == nil) {
        
        [self reloadRuler];
    }
    
    CGSize size = self.bounds.size;
    self.indicatorView.frame = CGRectMake(size.width * 0.5, size.height - self.indicatorLength, 1, self.indicatorLength);
    // 设置滚动视图内容间距
    CGSize textSize = [self maxValueTextSize];
    CGFloat offset = size.width * 0.5 - textSize.width;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
}


#pragma mark  ----  代理

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat spacing = self.configurationModel.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    CGFloat offset = targetContentOffset->x + size.width * 0.5 - textSize.width;
    NSInteger steps = (NSInteger)(offset / spacing + 0.5);
    targetContentOffset->x = -(size.width * 0.5 - textSize.width - steps * spacing) - 0.5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating)) {
        return;
    }
    
    CGFloat spacing = self.configurationModel.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    CGFloat offset = 0;
    offset = scrollView.contentOffset.x + size.width * 0.5 - textSize.width;
    NSInteger steps = (NSInteger)(offset / spacing + 0.5);
    CGFloat value = self.configurationModel.minValue + steps * self.configurationModel.valueStep/( self.configurationModel.midCount * self.configurationModel.smallCount);
    
    if (value != _selectedValue && (value >= self.configurationModel.minValue && value <= self.configurationModel.maxValue)) {
        _selectedValue = value;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark  ----  自定义函数

//设置界面
- (void)setupUI {
    
    // 滚动视图
    [self addSubview:self.scrollView];
    // 标尺图像
    [self.scrollView addSubview:self.rulerImageView];
    // 指示器视图
    [self addSubview:self.indicatorView];
}

//绘制标尺相关方法
- (void)reloadRuler {
    
    UIImage *image = [self rulerImage];
    if (image == nil) {
        return;
    }
    
    self.rulerImageView.image = image;
    self.rulerImageView.backgroundColor = self.configurationModel.rulerBackgroundColor;
    [self.rulerImageView sizeToFit];
    self.scrollView.contentSize = self.rulerImageView.image.size;
    
    // 水平标尺靠下对齐
    CGRect rect = self.rulerImageView.frame;
    rect.origin.y = self.scrollView.bounds.size.height - self.rulerImageView.image.size.height;
    self.rulerImageView.frame = rect;
    
    // 更新初始值
    self.selectedValue = _selectedValue;
}

- (UIImage *)rulerImage {
    
    // 1. 常数计算
    CGFloat steps = [self stepsWithValue: self.configurationModel.maxValue];
    if (steps == 0) {
        
        return nil;
    }
    
    // 水平方向绘制图像的大小
    CGSize textSize = [self maxValueTextSize];
    CGFloat height = self.scrollView.frame.size.height - self.rulerImageView.frame.size.height;
    //刻度线和图片前后的间距，避免刻度值被切割
    CGFloat startX = textSize.width;
    //刻度图片的宽高
    CGRect rect = CGRectMake(0, 0, steps * self.configurationModel.minorScaleSpacing + 2 * startX, height);
    
    // 2. 绘制图像
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    // 2-1 绘制刻度线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = self.configurationModel.minValue; i <= self.configurationModel.maxValue; i += self.configurationModel.valueStep) {
        
        // 绘制主刻度线
        CGFloat x = (i - self.configurationModel.minValue) / self.configurationModel.valueStep * self.configurationModel.minorScaleSpacing * (self.configurationModel.midCount * self.configurationModel.smallCount) + startX;
        // 绘制主刻度上
        [path moveToPoint:CGPointMake(x, 0)];
        [path addLineToPoint:CGPointMake(x,self.majorScaleLength)];
        
        // 绘制主刻度下
        [path moveToPoint:CGPointMake(x, height)];
        [path addLineToPoint:CGPointMake(x, height - self.majorScaleLength)];
        
        if (i == self.configurationModel.maxValue) {
            
            break;
        }
        
        // 绘制小刻度线上
        for (NSInteger j = 1; j < (self.configurationModel.midCount*self.configurationModel.smallCount); j++) {
            
            CGFloat scaleX = x + j * self.configurationModel.minorScaleSpacing;
            //上
            [path moveToPoint:CGPointMake(scaleX, 0)];
            CGFloat scaleY =((j%self.configurationModel.smallCount == 0) ? self.middleScaleLength : self.minorScaleLength);
            //上
            [path addLineToPoint:CGPointMake(scaleX, scaleY)];
        }
        
        // 绘制小刻度线下
        for (NSInteger j = 1; j < (self.configurationModel.midCount*self.configurationModel.smallCount); j++) {
            
            CGFloat scaleX = x + j * self.configurationModel.minorScaleSpacing;
            [path moveToPoint:CGPointMake(scaleX, height)];
            CGFloat scaleY = height - ((j%self.configurationModel.smallCount == 0) ? self.middleScaleLength : self.minorScaleLength);
            [path addLineToPoint:CGPointMake(scaleX, scaleY)];
        }
    }
    
    [self.configurationModel.scaleColor set];
    [path stroke];
    
    // 2-2 绘制刻度值
    NSDictionary *strAttributes = [self scaleTextAttributes];
    for (NSInteger i = self.configurationModel.minValue; i <= self.configurationModel.maxValue; i += self.configurationModel.valueStep) {
        
        NSString *str = @(i).description;
        CGRect strRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:strAttributes
                                           context:nil];
        strRect.origin.x = (i - self.configurationModel.minValue) / self.configurationModel.valueStep * self.configurationModel.minorScaleSpacing *( self.configurationModel.midCount*self.configurationModel.smallCount) + startX - strRect.size.width * 0.5;
        strRect.origin.y =_scrollView.frame.size.height*0.5-textSize.height*0.5;
        [str drawInRect:strRect withAttributes:strAttributes];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

//总的格数
- (CGFloat)stepsWithValue:(CGFloat)value {
    
    if (self.configurationModel.minValue >= value || self.configurationModel.valueStep <= 0) {
        
        return 0;
    }
    
    return (value - self.configurationModel.minValue) / self.configurationModel.valueStep *( self.configurationModel.midCount * self.configurationModel.smallCount);
}

//最大刻度值的宽高
- (CGSize)maxValueTextSize {
    
    NSString *scaleText = @(self.configurationModel.maxValue).description;
    CGSize size = [scaleText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:[self scaleTextAttributes]
                                          context:nil].size;
    
    return CGSizeMake(floor(size.width), floor(size.height));
}

- (NSDictionary *)scaleTextAttributes {
    
    CGFloat fontSize = self.scaleFontSize * [UIScreen mainScreen].scale * 0.6;
    
    return @{NSForegroundColorAttributeName: self.configurationModel.scaleFontColor,
             NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]};
}


#pragma mark  ----  SET方法
//指示器颜色
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    
    _indicatorView.backgroundColor = indicatorColor;
}

//选中的数值
- (void)setSelectedValue:(CGFloat)selectedValue {
    
    if (selectedValue < self.configurationModel.minValue || selectedValue > self.configurationModel.maxValue || self.configurationModel.valueStep <= 0) {
        
        return;
    }
    
    _selectedValue = selectedValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    CGFloat spacing = self.configurationModel.minorScaleSpacing;
    CGSize size = self.bounds.size;
    CGSize textSize = [self maxValueTextSize];
    CGFloat offset = 0;
    
    // 计算偏移量
    CGFloat steps = [self stepsWithValue:selectedValue];
    offset = size.width * 0.5 - textSize.width - steps * spacing;
    _scrollView.contentOffset = CGPointMake(-offset, 0);
}

#pragma mark  ----  懒加载

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //自动布局
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.layer.borderWidth=0.5;
        _scrollView.layer.borderColor=self.configurationModel.rulerBackgroundColor.CGColor;
    }
    return _scrollView;
}

-(UIImageView *)rulerImageView{
    
    if (!_rulerImageView) {
        
         _rulerImageView = [[UIImageView alloc] init];
    }
    return _rulerImageView;
}

-(UIView *)indicatorView{
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = self.configurationModel.indicatorColor;
    }
    return _indicatorView;
}

//指示器高度
- (CGFloat)indicatorLength {
    
    if (_indicatorLength <= 0) {
        
        _indicatorLength = CGRectGetHeight(self.frame);
    }
    return _indicatorLength;
}



//主刻度长度
- (CGFloat)majorScaleLength {
    
    if (_majorScaleLength <= 0) {
        
        _majorScaleLength = CGRectGetHeight(self.frame) / 3.0;
    }
    return _majorScaleLength;
}

//中间刻度长度
- (CGFloat)middleScaleLength {
    
    if (_middleScaleLength <= 0) {
        
        _middleScaleLength = CGRectGetHeight(self.frame) / 4.0;
    }
    return _middleScaleLength;
}

//小刻度长度
- (CGFloat)minorScaleLength {
    
    if (_minorScaleLength <= 0) {
        
        _minorScaleLength = CGRectGetHeight(self.frame) / 5.0;
    }
    return _minorScaleLength;
}

//刻度字体尺寸
- (CGFloat)scaleFontSize {
    
    if (_scaleFontSize <= 0) {
        
        _scaleFontSize = kScaleDefaultFontSize;
    }
    return _scaleFontSize;
}
@end
