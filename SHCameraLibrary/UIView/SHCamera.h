//
//  SHCamera.h
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//  最底层相机View，只具备显示功能

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SHCamera : UIView

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong)AVCaptureSession *session;
// 预览图层,来显示照相机拍摄到的画面
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
// AVCaptureDeviceInput对象是输入流
@property (nonatomic,strong)AVCaptureDeviceInput *videoInput;

@property (nonatomic,strong) AVCaptureDevice * frontCamera;
@property (nonatomic,strong) AVCaptureDevice * backCamera;


-(instancetype)initWithFrame:(CGRect)frame;

@end
