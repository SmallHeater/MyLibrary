//
//  SHSpeechRecognitionLibrary.h
//  SHSpeechRecognitionLibrary
//
//  Created by xianjunwang on 2018/4/4.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  语音转文字

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SHSFSpeechRecognizerAuthorizationStatus) {
    SHSFSpeechRecognizerAuthorizationStatusNotDetermined,//没有授权语音识别
    SHSFSpeechRecognizerAuthorizationStatusDenied,//用户被拒绝访问语音识别
    SHSFSpeechRecognizerAuthorizationStatusRestricted,//不能在该设备上进行语音识别
    SHSFSpeechRecognizerAuthorizationStatusAuthorized,//可以语音识别
};


@interface SHSpeechRecognitionLibrary : NSObject

//权限判断
-(void)requestAuthorization:(void(^)(SHSFSpeechRecognizerAuthorizationStatus status))handler;
//开始录音
-(void)startRecording:(void(^)(NSString *resultStr))resultBlock;
//停止录音
-(void)stopRecoding;
@end
