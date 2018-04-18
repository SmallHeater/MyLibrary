//
//  SpeechRecognitionController.m
//  SHSpeechRecognitionLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SpeechRecognitionController.h"



@interface SpeechRecognitionController ()<SFSpeechRecognizerDelegate>

@property(nonatomic,strong) SFSpeechRecognizer * recognizer;
//语音识别功能
@property(nonatomic,strong) SFSpeechAudioBufferRecognitionRequest * recognitionRequest;
@property(nonatomic,strong) SFSpeechRecognitionTask * recognitionTask;
@property(nonatomic,strong) AVAudioEngine * audioEngine;
@property(nonatomic,strong)AVAudioInputNode *buffeInputNode;

@end

@implementation SpeechRecognitionController

#pragma mark  ----  自定义函数
//权限判断
-(void)requestAuthorization:(void(^)(SFSpeechRecognizerAuthorizationStatus status))handler{
    
    [SFSpeechRecognizer requestAuthorization:handler];
}

//开始识别
-(void)startRecording:(void(^)(NSString *resultStr))resultBlock{
    
//    [self stopRecording];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bool  audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    bool  audioBool1= [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    bool  audioBool2= [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (audioBool || audioBool1||  audioBool2) {
        
        NSLog(@"可以使用");
    }else{
        
        NSLog(@"这里说明有的功能不支持");
    }
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.buffeInputNode = self.audioEngine.inputNode;
    //true,时时回调。false,一句一回调。默认true。
    self.recognitionRequest.shouldReportPartialResults = NO;
    
    
    //开始识别任务
    __weak SpeechRecognitionController * wekSelf = self;
    self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if (result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * str = [[result bestTranscription] formattedString]; //语音转文本
                resultBlock(str);
                NSLog(@"转换结果:%@",str);
            });
        }
        if (error) {
            
            //结束监听
            [self.audioEngine stop];
            [self.buffeInputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
            NSLog(@"错误信息2：%@",error.userInfo);
        }
    }];
    
    //监听一个标识位并拼接流文件
    AVAudioFormat *recordingFormat = [self.buffeInputNode outputFormatForBus:0];
    [self.buffeInputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    //准备启动引擎
    [self.audioEngine prepare];
    NSError * error = nil;
    if (![self.audioEngine startAndReturnError:&error]) {
     
        NSLog(@"错误信息1：%@",error.userInfo);
    }
}

//停止
-(void)stopRecording{
    
    if ([self.audioEngine isRunning]) {
        
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
    }
    
    if (self.recognitionTask) {
        
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
}

#pragma mark  ----  代理方法
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{

    if (available) {
    
    }else{

    
    }
}


#pragma mark  ----  懒加载
-(SFSpeechRecognizer *)recognizer{

    if (!_recognizer) {

        //将设备识别语音为中文
        NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _recognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
        //设置代理
        _recognizer.delegate = self;
    }
    return _recognizer;
}

//创建录音引擎
-(AVAudioEngine *)audioEngine{
    
    if (!_audioEngine) {
        
        _audioEngine = [[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}


@end
