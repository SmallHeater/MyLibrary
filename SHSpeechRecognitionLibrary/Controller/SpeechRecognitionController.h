//
//  SpeechRecognitionController.h
//  SHSpeechRecognitionLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>

@interface SpeechRecognitionController : NSObject

//权限判断
-(void)requestAuthorization:(void(^)(SFSpeechRecognizerAuthorizationStatus status))handler;
//开始识别
-(void)startRecording:(void(^)(NSString *resultStr))resultBlock;
//停止
-(void)stopRecording;

@end
