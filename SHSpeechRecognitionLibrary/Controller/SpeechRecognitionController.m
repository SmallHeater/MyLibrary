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

@end

@implementation SpeechRecognitionController

#pragma mark  ----  自定义函数
//权限判断
-(void)requestAuthorization:(void(^)(SFSpeechRecognizerAuthorizationStatus status))handler{
    
    [SFSpeechRecognizer requestAuthorization:handler];
}

//开始识别
-(void)startRecording:(void(^)(NSString *resultStr))resultBlock{
    
    [self stopRecording];
    
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
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    self.recognitionRequest.shouldReportPartialResults = true;
    
    
    //开始识别任务
    self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        bool isFinal = false;
        if (result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [[result bestTranscription] formattedString]; //语音转文本
                resultBlock(str);
                NSLog(@"转换结果:%@",str);
            });
            
            isFinal = [result isFinal];
        }
        if (error || isFinal) {
            
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
        }
    }];
    
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    bool audioEngineBool = [self.audioEngine startAndReturnError:nil];
    NSLog(@"%d",audioEngineBool);
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
