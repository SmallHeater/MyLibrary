//
//  ViewController.m
//  ScaleDemo
//
//  Created by xianjunwang on 2018/3/20.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "ScaleViewController.h"
#import "SHScaleControlLibrary.h"


@interface ScaleViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic,strong) SHScaleControlLibrary * control;
@property (nonatomic, strong) UIView * ruler;
//刻度尺配置模型
@property (nonatomic,strong) ScaleControlConfigurationModel * configurationModel;

@end

@implementation ScaleViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationBar.navTitle = @"刻度尺演示";
    
    [self.view addSubview:self.textfield];
    [self.view addSubview:self.ruler];
}

#pragma mark  ----  代理
#pragma mark  ----  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.floatValue > self.configurationModel.maxValue || textField.text.floatValue < self.configurationModel.minValue) {
        
        return NO;
    }
    else{
        
        [self.control setSelectedValue:textField.text.floatValue];
        [textField resignFirstResponder];
        return YES;
    }
}

#pragma mark  ----  自定义函数



#pragma mark  ----  懒加载
-(SHScaleControlLibrary *)control{
    
    if (!_control) {
     
        _control = [[SHScaleControlLibrary alloc] init];
    }
    return _control;
}

-(UIView *)ruler{
    
    if (!_ruler) {
        
        _ruler = [self.control getScaleControlViewWithFrame:CGRectMake(0, 220,[UIScreen mainScreen].bounds.size.width, 120) andConfigurationModel:self.configurationModel andDefaultSelectValue:0 andBlock:^(float selectValue) {
            
            _textfield.text = [NSString stringWithFormat:@"%.f", selectValue];
        }];
        _ruler.backgroundColor = [UIColor grayColor];
    }
    return _ruler;
}

-(ScaleControlConfigurationModel *)configurationModel{
    
    if (!_configurationModel) {
        
        _configurationModel = [[ScaleControlConfigurationModel alloc] init];
        _configurationModel.minValue = 0;// 最小值
        _configurationModel.maxValue = 100;// 最大值
        _configurationModel.valueStep = 10;// 步长，两个标记刻度之间相差大小
        _configurationModel.minorScaleSpacing = 10;// 小刻度间距
        _configurationModel.rulerBackgroundColor = [UIColor redColor];// 刻度尺背景颜色，默认为 `clearColor`
        _configurationModel.scaleColor = [UIColor greenColor];// 刻度颜色，默认为 `lightGrayColor`
        _configurationModel.scaleFontColor = [UIColor yellowColor];// 刻度字体颜色，默认为 `darkGrayColor`
        _configurationModel.indicatorColor = [UIColor blackColor];// 指示器颜色，默认 `redColor`
        _configurationModel.midCount= 1;//几个大格标记一个刻度
        _configurationModel.smallCount= 5;//一个大格几个小格
    }
    return _configurationModel;
}

-(UITextField *)textfield{
    
    if (!_textfield) {
        
        _textfield=[[UITextField alloc]initWithFrame:CGRectMake(80, 100, 100, 40)];
        _textfield.backgroundColor=[UIColor lightGrayColor];
        _textfield.textAlignment=NSTextAlignmentCenter;
        _textfield.delegate=self;
    }
    return _textfield;
}


@end
