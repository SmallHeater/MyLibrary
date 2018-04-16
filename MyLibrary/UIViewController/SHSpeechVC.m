//
//  SHSpeechVC.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHSpeechVC.h"
#import "SHSpeechRecognitionLibrary.h"
#import "MBProgressHUD.h"

@interface SHSpeechVC ()
//开始识别按钮
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) UILabel * resultLabel;
//控制器
@property (nonatomic,strong) SHSpeechRecognitionLibrary * control;
@end

@implementation SHSpeechVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.resultLabel];
    //请求权限
    [self.control requestAuthorization:^(SHSFSpeechRecognizerAuthorizationStatus status) {
        
        bool isButtonEnabled = false;
        NSString * str;
        switch (status) {
            case SHSFSpeechRecognizerAuthorizationStatusAuthorized:
                isButtonEnabled = true;
                NSLog(@"可以语音识别");
                break;
            case SHSFSpeechRecognizerAuthorizationStatusDenied:
                isButtonEnabled = false;
                str = @"用户被拒绝访问语音识别";
                break;
            case SHSFSpeechRecognizerAuthorizationStatusRestricted:
                isButtonEnabled = false;
                str = @"不能在该设备上进行语音识别";
                break;
            case SHSFSpeechRecognizerAuthorizationStatusNotDetermined:
                isButtonEnabled = false;
                str = @"没有授权语音识别";
                break;
            default:
                break;
        }
        self.recordBtn.enabled = isButtonEnabled;
        if (!isButtonEnabled) {
            
            [MBProgressHUD displayHudError:str];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)recordBtnClicked:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        //开始录音
        [self.control startRecording:^(NSString *resultStr) {
            
            self.resultLabel.text = [[NSString alloc] initWithFormat:@"识别结果“%@",resultStr];
        }];
    }
    else{
        
        //停止录音
        [self.control stopRecoding];
    }
}

#pragma mark  ----  懒加载

-(UIButton *)recordBtn{
    
    if (!_recordBtn) {
        
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CGRectMake(100, 100, 80, 40);
        [_recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"结束录制" forState:UIControlStateSelected];
        [_recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

-(SHSpeechRecognitionLibrary *)control{
    
    if (!_control) {
        
        _control = [[SHSpeechRecognitionLibrary alloc] init];
    }
    return _control;
}

-(UILabel *)resultLabel{
    
    if (!_resultLabel) {
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, SCREENWIDTH - 20, 40)];
    }
    return _resultLabel;
}
@end
