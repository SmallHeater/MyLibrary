//
//  SHSpeechRecognitionLibrary.m
//  SHSpeechRecognitionLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHSpeechRecognitionLibrary.h"
#import "SpeechRecognitionController.h"

@interface SHSpeechRecognitionLibrary ()

@property (nonatomic,strong) SpeechRecognitionController * controller;

@end

@implementation SHSpeechRecognitionLibrary

#pragma mark  ----  生命周期函数

#pragma mark  ----  自定义函数

//权限判断
-(void)requestAuthorization:(void(^)(SHSFSpeechRecognizerAuthorizationStatus status))handler{
    
    [self.controller requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
       
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
               
                handler(SHSFSpeechRecognizerAuthorizationStatusAuthorized);
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                
                handler(SHSFSpeechRecognizerAuthorizationStatusDenied);
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                
                handler(SHSFSpeechRecognizerAuthorizationStatusRestricted);
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                
                handler(SHSFSpeechRecognizerAuthorizationStatusNotDetermined);
                break;
            default:
                break;
        }
    }];
}


//开始录音
-(void)startRecording:(void(^)(NSString *resultStr))resultBlock{
    
    [self.controller startRecording:resultBlock];
}


//停止录音
-(void)stopRecoding{
    
    [self.controller stopRecording];
}

#pragma mark  ---- 懒加载
-(SpeechRecognitionController *)controller{
    
    if (!_controller) {
        
        _controller = [[SpeechRecognitionController alloc] init];
    }
    return _controller;
}




@end
