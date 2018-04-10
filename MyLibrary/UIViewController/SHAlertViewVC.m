//
//  ViewController.m
//  UIAlertViewManager
//
//  Created by xianjunwang on 2017/8/21.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHAlertViewVC.h"
#import "SHAlertViewManagerLibrary.h"


@interface SHAlertViewVC ()<UIAlertViewDelegate,UIActionSheetDelegate>{
    NSUInteger alertNumber;
    NSUInteger actionNumber;
    NSUInteger viewNumber;
}

@property (nonatomic,strong) UIButton * firstBtn;
@property (nonatomic,strong) UIButton * secondBtn;
@property (nonatomic,strong) UIButton * thirdBtn;
@property (nonatomic,strong) UIButton * forthBtn;

@end

@implementation SHAlertViewVC

#pragma mark  ----  生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navTitle = @"AlertView管理组件演示页面";
    alertNumber = 0;
    actionNumber = 0;
    viewNumber = 0;
    
    [self.view addSubview:self.firstBtn];
    [self.view addSubview:self.secondBtn];
    [self.view addSubview:self.thirdBtn];
    [self.view addSubview:self.forthBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  ----  自定义函数

-(UIButton *)getBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andAction:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (IBAction)addAlert:(id)sender {
    
    NSString * title = [[NSString alloc] initWithFormat:@"第%ld个alert",(long)alertNumber];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:@"弹出alert了呀" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [SHAlertViewManagerLibrary addShowView:alert];
    alertNumber++;
}

- (IBAction)addAction:(id)sender {
    
    NSString * title = [[NSString alloc] initWithFormat:@"第%ld个action",(long)actionNumber];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选项一" otherButtonTitles:@"选项二", nil];
    [SHAlertViewManagerLibrary addShowView:actionSheet];
    actionNumber++;
}

- (IBAction)addView:(id)sender {
    
    NSString * title = [[NSString alloc] initWithFormat:@"第%ld个view",(long)viewNumber];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];

    view.backgroundColor = [UIColor grayColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
    label.text = title;
    [view addSubview:label];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(60, 0, 40, 40);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [SHAlertViewManagerLibrary addShowView:view];
    viewNumber++;
}


- (IBAction)addAlertAndAction:(id)sender {
    [self addAlert:nil];
    [self addAction:nil];
    [self addAction:nil];
    [self addView:nil];
    [self addAlert:nil];
    [self addAlert:nil];
}

-(void)btnClicked:(UIButton *)btn{
    UIView * parentView = btn.superview;
    [SHAlertViewManagerLibrary deleShowView:parentView];
}

#pragma mark  ----  代理
#pragma mark  ----  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [SHAlertViewManagerLibrary deleShowView:alertView];
}


#pragma mark  ----  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [SHAlertViewManagerLibrary deleShowView:actionSheet];
}

#pragma mark  ----  懒加载
-(UIButton *)firstBtn{
    
    if (!_firstBtn) {
        
        _firstBtn = [self getBtnWithFrame:CGRectMake(100, 100, 200, 40) andTitle:@"添加一个alert" andAction:@selector(addAlert:)];
    }
    return _firstBtn;
}

-(UIButton *)secondBtn{
    
    if (!_secondBtn) {
        
        _secondBtn = [self getBtnWithFrame:CGRectMake(CGRectGetMinX(self.firstBtn.frame), CGRectGetMaxY(self.firstBtn.frame) + 20, CGRectGetWidth(self.firstBtn.frame), CGRectGetHeight(self.firstBtn.frame)) andTitle:@"添加一个action" andAction:@selector(addAction:)];
    }
    return _secondBtn;
}

-(UIButton *)thirdBtn{
    
    if (!_thirdBtn) {
        
        _thirdBtn = [self getBtnWithFrame:CGRectMake(CGRectGetMinX(self.secondBtn.frame), CGRectGetMaxY(self.secondBtn.frame) + 20, CGRectGetWidth(self.secondBtn.frame), CGRectGetHeight(self.secondBtn.frame)) andTitle:@"添加一个view" andAction:@selector(addView:)];
    }
    return _thirdBtn;
}

-(UIButton *)forthBtn{
    
    if (!_forthBtn) {
        
        _forthBtn = [self getBtnWithFrame:CGRectMake(CGRectGetMinX(self.thirdBtn.frame), CGRectGetMaxY(self.thirdBtn.frame) + 20, CGRectGetWidth(self.thirdBtn.frame), CGRectGetHeight(self.thirdBtn.frame)) andTitle:@"添加多个alert和action" andAction:@selector(addAlertAndAction:)];
    }
    return _forthBtn;
}
@end
